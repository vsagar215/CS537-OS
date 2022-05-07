#include <stdio.h>
#include "ext2_fs.h"
#include "read_ext2.h"
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

// Globals
int inode_num = -999; // Track inode number 
int bytes_count = -999;
int entered = 0;
int final_block_bytes_g;
char dir_name[537];
int valid_inodes[101];
int passed_nodes[101];
int counter = 1;
int valid = 0;

// int foobar = 0;

// Prototypes
void handle_direct_blocks(int block_addr, int size, int fd, int file_i);
void handle_s_in_direct_blocks(int block_addr, int size, int fd, int file_i);
void handle_d_in_direct_blocks(int block_addr, int size, int fd, int file_i);
void handle_dir(struct ext2_inode *inode, int fd);

int main(int argc, char **argv) {
	if (argc != 3) {
		printf("expected usage: ./runscan inputfile outputfile\n");
		exit(0);
	}
	
	DIR *dir = opendir(argv[2]);
	if(dir != NULL) {
		printf("Ya done messed up\n");
		exit(1);	
	}
	
	int dir_fd = mkdir(argv[2], 0755); dir_fd=dir_fd;// TODO: Figure out where to use this.
	int fd;
	strcpy(dir_name, argv[2]);
	fd = open(argv[1], O_RDONLY);    /* open disk image */

	ext2_read_init(fd);

	struct ext2_super_block super;
	struct ext2_group_desc group;
	for (unsigned int j = 0; j < num_groups; j++) {
		// example read first the super-block and group-descriptor
		read_super_block(fd, j, &super);
		read_group_desc(fd, j, &group);
		
		printf("There are %u inodes in an inode table block and %u blocks in the idnode table\n", inodes_per_block, itable_blocks);
		//iterate the first inode block
		off_t start_inode_table = locate_inode_table(j, &group);
		printf("DEBUG inodes per block: %d\n", inodes_per_block);
		inode_num = -1;
		for (unsigned int i = 0; i < inodes_per_group; i++) {

			inode_num++;
			printf("inode %u: \n", i);
			struct ext2_inode *inode = malloc(sizeof(struct ext2_inode));
			int isReg= -1;
			int isDir= -1;
			read_inode(fd, j, start_inode_table, i, inode);
			/* the maximum index of the i_block array should be computed from i_blocks / ((1024<<s_log_block_size)/512)
			* or once simplified, i_blocks/(2<<s_log_block_size)
			* https://www.nongnu.org/ext2-doc/ext2.html#i-blocks
			*/
			unsigned int i_blocks = inode->i_blocks/(2<<super.s_log_block_size);
			
			isReg = S_ISREG(inode->i_mode) ?1 :0;
			isDir = S_ISDIR(inode->i_mode) ?1 :0;

			printf("number of blocks %u\n", i_blocks);
			printf("Is directory? %s \n Is Regular file? %s\n",
				isDir ? "true" : "false",
				isReg ? "true" : "false");
			
			if(isDir == 1) {
				handle_dir(inode, fd); // loop twice: 1) loop for files 2) loop for dirs
				continue; // MAYBE here?
			}

			int is_jpg = 0;
			char jpg_buffer[1024];
			char inode_name[1024];

			// Read first block
			lseek(fd, BLOCK_OFFSET(inode->i_block[0]), SEEK_SET);
			read(fd, jpg_buffer, 1024);
			
			// Checking if first block has JPG magic numbers
			if (jpg_buffer[0] == (char)0xff &&
			jpg_buffer[1] == (char)0xd8 &&
			jpg_buffer[2] == (char)0xff &&
			(jpg_buffer[3] == (char)0xe0 ||
			jpg_buffer[3] == (char)0xe1 ||
			jpg_buffer[3] == (char)0xe8)) {
				is_jpg = 1;
			}

			if(is_jpg != 1) continue;
			// TODO: Maintain list of valid inodes. Then scan those inside dirs, copy contents with valid file name
			// Create and open file
			sprintf(inode_name, "%s/%s%d%s", dir_name, "file-", inode_num, ".jpg");
			int file_i = open(inode_name, O_CREAT | O_TRUNC | O_WRONLY, 0666); // TODO: Assert fp is not null?
			// Add to array
			valid_inodes[0] = valid_inodes[0] + 1;
			int i;
			for(i = 1; i < valid_inodes[0] + 1; ++i) valid_inodes[i] = inode_num;

			// how many blocks to read
			int final_block_bytes = inode->i_size % 1024;
			final_block_bytes_g = final_block_bytes;
			bytes_count = inode->i_size;
			
			for(unsigned int i=0; i<EXT2_N_BLOCKS; i++)
			{
				if(bytes_count <= 0) break;
				// TODO: LATER Check if file spans just direct or direct and indirect blocks 
				if (i < EXT2_NDIR_BLOCKS) {
					int consumed;
					printf("Block %2u : %u\n", i, inode->i_block[i]);				
					if(bytes_count > 1024){
						consumed = 1024;
						handle_direct_blocks((int) inode->i_block[i], consumed, fd, file_i);
					} else{
						entered++;
						consumed = final_block_bytes;
						handle_direct_blocks((int) inode->i_block[i], consumed, fd, file_i);
					}
					bytes_count -= consumed;
				}
				else if (i == EXT2_IND_BLOCK){
					printf("Single   : %u size: %d\n", inode->i_block[i], inode->i_size); 			/* single indirect block */
					if(bytes_count > 1024){
						handle_s_in_direct_blocks((int) inode->i_block[i], 1024, fd, file_i);
					}else{
						entered++;
						handle_s_in_direct_blocks((int) inode->i_block[i], final_block_bytes, fd, file_i);
					}
				}                             
				else if (i == EXT2_DIND_BLOCK){                             /* double indirect block */
					printf("Double   : %u\n", inode->i_block[i]);
					if(bytes_count > 1024)
						handle_d_in_direct_blocks((int) inode->i_block[i], 1024, fd, file_i);
					else{
						entered++;
						handle_d_in_direct_blocks((int) inode->i_block[i], final_block_bytes, fd, file_i);
					}
				}
				else if (i == EXT2_TIND_BLOCK){                            	/* triple indirect block */
					printf("Triple   : %u\n", inode->i_block[i]);
				}
			}
			close(file_i); // TODO: Move it
			free(inode);
		}
	}
	close(fd);
	printf("----------------------------PRINTS----------------------------\n");
	printf("Entered count: %d\n", entered);
	printf("Valid: %d\n", valid);
	printf("Bytes Count: %d\nBytes Left: %d\n", bytes_count, final_block_bytes_g);
	int i;
	for(i = 0; i < valid_inodes[0] + 1; ++i) printf("%d\t", valid_inodes[i]);
	for(i = 0; i < counter + 1; ++i) printf("%d\t", passed_nodes[i]);
	printf("\n------------------------END OF PRINTS-------------------------\n");
}

// dec total bytes by byte
void handle_direct_blocks(int block_addr, int size, int fd, int file_i) {
	
	char buffer[1024];
	// Returning if empty block
	if(block_addr == 0) return;
	
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET);
	read(fd, buffer, size);
	write(file_i, buffer, size);
}

// dec total bytes by block(1024)
// Call back direct block from within indirection
void handle_s_in_direct_blocks(int block_addr, int size, int fd, int file_i){
	
	int ind_buffer[256]; // buffer ind block as an int
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET);
	read(fd, ind_buffer, sizeof(ind_buffer));

	// Read pointers from indirect block
	for (unsigned int i = 0; i < 256; ++i){
		if(bytes_count <= 1024){
			// entered++;
			handle_direct_blocks(ind_buffer[i], final_block_bytes_g, fd, file_i);
			// bytes_count -= bytes_left_g;
		} else{

		//check if bytes count is less than 1024
		// then call direct on bytes_count
		// else direct on size
			// entered++;
			handle_direct_blocks(ind_buffer[i], size, fd, file_i);
			bytes_count -= 1024;
		}
	}
}

// TODO: Rewrite to call single indirect block handler
void handle_d_in_direct_blocks(int block_addr, int size, int fd, int file_i) {
	int sec_ind_buffer[256]; // buffer ind block as an int
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET);
	read(fd, sec_ind_buffer, sizeof(sec_ind_buffer));

	// Read pointers from indirect block
	for (unsigned int i = 0; i < 256; ++i){

		if(bytes_count <= 1024){
			// entered++;
			handle_s_in_direct_blocks(sec_ind_buffer[i], final_block_bytes_g, fd, file_i);
			// bytes_count -= bytes_left_g;
		} else{
			handle_s_in_direct_blocks(sec_ind_buffer[i], size, fd, file_i);
			// bytes_count -= 1024*256;
		}
	} 
}

// TODO: Complete writing
void write_inode(int jpg_inode, char file_name[1024]){

	/*
		1) open the file of the inode num
		2) read the contents
		3) copy contents to actual file
	*/

	// 1
	FILE *inode_fd, *output_fd;

	// file to read
	char inode_name[1024];
	sprintf(inode_name, "%s/%s%d%s", dir_name, "file-", jpg_inode, ".jpg");

	char inode_file_path[1024], c;
	// file to write
	sprintf(inode_file_path, "%s/%s%s", dir_name, file_name, ".jpg");

	inode_fd = fopen(inode_name, "r");
	if(inode_fd == NULL) {
		printf("inode file path wrong\n");
		exit(1);
	}
	
	output_fd = fopen(inode_file_path, "w");
	if(output_fd == NULL) {
		printf("output file path wrong\n");
		exit(1);
	}


	c = fgetc(inode_fd);
	while(c != EOF) {
		fputc(c, output_fd);
		c = fgetc(inode_fd);
	}
}

void handle_dir(struct ext2_inode *inode, int fd) {
   printf("--------------------------- DIRECTORY NODE -------------------------------\n");

   char buffer[1024];
   int curr_offset = 0, max_offset = 1024;

   lseek(fd, BLOCK_OFFSET(inode->i_block[0]), SEEK_SET); // reading first block of dir
   read(fd, buffer, 1024);

    while(1) {
        struct ext2_dir_entry* dentry = (struct ext2_dir_entry*) & ( buffer[curr_offset] );
        int dir_inode_num = dentry->inode;

		if(dentry->inode == 0) {
            // curr_offset += 8+(dentry->name_len + (4-(dentry->name_len %4)) );
            // continue; // break, not continue
			break;
        }

		//check if inode is in valid array
		for(int i = 1; i < valid_inodes[0]; i ++){
			if(dir_inode_num == valid_inodes[i]) {
				valid = 1;
				break;
			}
		}

		if(!valid) {
			curr_offset += 8+(dentry->name_len + (4-(dentry->name_len %4)) );
            continue;
		}

		// passed_nodes[counter] = dir_inode_num;
		// counter++;
 
        int name_len = dentry->name_len & 0xFF;
        char name[EXT2_NAME_LEN];
 
        strncpy(name, dentry->name, name_len);
        name[name_len] = '\0';
 
        /*
           read in the inode that this directory entry points to
           copy the inode to the correct file
        */
        // struct ext2_inode *inode = malloc(sizeof(struct ext2_inode));
 
        // read_inode(fd, ngroup, offset, inode_num, inode);
		// TODO: Stubbing filepath

        // write_inode(dir_inode_num, name);
 
        //dir entry debug info
        printf("Entry name is --%s--\n", name);
        printf("inode: %d\n", dentry->inode);
        printf("rec_len: %d\n", dentry->rec_len);
        printf("name_len: %d\n", dentry->name_len);
        //curr_offset += dentry->rec_len;
        printf("before curr_offset: %d\n", curr_offset);
        printf("thing (not adding 8): %d\n", (dentry->name_len + (4-(dentry->name_len %4)) ));
        printf("padding: %d\n", (4-(dentry->name_len %4) ));


        curr_offset += dentry->name_len%4 == 0? 8+dentry->name_len : 8+(dentry->name_len + (4-(dentry->name_len %4)) );
        // printf("after curr_offset: %d\n\n", curr_offset);



        // free(inode);
        if(curr_offset >= max_offset) break;
    }

	   printf("--------------------------- FIN -------------------------------\n");

}