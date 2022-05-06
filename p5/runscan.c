#include <stdio.h>
#include "ext2_fs.h"
#include "read_ext2.h"
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

// Track inode number
int inode_num = -999;

void handle_direct_blocks(struct ext2_inode *inode, int is_jpg, int isReg, int i, int fd, char dir_name[537]) {

	// Returning if empty block or a dir
	char buffer[1024];
	char inode_name[537];
	// char file_name[537];

	if(inode->i_block[i] == 0 || isReg != 1) return; 

	// Seeking to the correct data block
	lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET); // TODO: Fix for only size of file, not entire block
	read(fd, buffer, 1024);

	// Checking if first block has JPG magic numbers
	if (buffer[0] == (char)0xff &&
	buffer[1] == (char)0xd8 &&
	buffer[2] == (char)0xff &&
	(buffer[3] == (char)0xe0 ||
	buffer[3] == (char)0xe1 ||
	buffer[3] == (char)0xe8)) {
		is_jpg = 1;
	}

	// If the file is not a JPG
	if(is_jpg != 1) return;
	
	// // ---- DEBUG OUTPUT ---- 
	// printf("----------------------\n");
	// printf("------is_jpeg: %d------\n", is_jpg);
	// printf("----------------------\n");
	// lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET);
	// figure out how to write to file
	// char *file_name = "file-\0";
	// // ---- DEBUG OUTPUT ---- 
	
	sprintf(inode_name, "%s/%s%d%s", dir_name, "file-", inode_num, ".jpg"); 
	// sprintf(file_name, "%s/%s", dir_name, "a.jpg"); // TODO: Remove hard coding and retrieve filename
	int file_i = open(inode_name, O_CREAT, 0666); // TODO: Assert fp is not null??
	// int file_n = open(file_name, O_CREAT, 0666);
	// TODO: Check why file empty
	write(file_i, buffer, sizeof(buffer)); 
	// write(file_n, buffer, sizeof(buffer));
	close(file_i);
	// close(file_n);

	// printf("size of inode: %d\n", inode->i_size);
}

/*
	enter the indirection
	iterate through indirection until null (offset by 4)
	add the data at each pointer into buffer

	do the jpg check
*/

// Call back direct block from within indirection
void handle_s_in_direct_blocks(struct ext2_inode *inode, int is_jpg, int isReg, int i, int fd, int dir_fd) {
	char buffer[1024];
	if(inode->i_block[i] == 0) return;// || isReg != 1) return; 
	
	
	dir_fd=dir_fd;
	isReg=isReg;
	
	int ind_buffer[256]; // buffer ind block as an int
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET);
	read(fd, ind_buffer, sizeof(ind_buffer));
	// printf("DEBUG %ld\n", sizeof(*ind_buffer));

	// Read pointers from indirect block
	// loop over the int buffer
	for (unsigned int i = 0; i<256; ++i){

		// Read data for every 4th offset
		lseek(fd, BLOCK_OFFSET(ind_buffer[i * 4]), SEEK_SET);
		read(fd, buffer, 1024);
		
		// Perform jpg check
		if (buffer[0] == (char)0xff &&
			buffer[1] == (char)0xd8 &&
			buffer[2] == (char)0xff &&
			(buffer[3] == (char)0xe0 ||
			buffer[3] == (char)0xe1 ||
			buffer[3] == (char)0xe8)) {
				is_jpg = 1;
		}
		is_jpg=is_jpg;
		// printf("----------------------\n");
		// printf("------is_jpeg: %d------\n", is_jpg);
		// printf("----------------------\n");
	}

}

void handle_d_in_direct_blocks(struct ext2_inode *inode, int is_jpg, int isReg, int i, int fd) {
	char buffer[1024];
	if(inode->i_block[i] == 0 || isReg != 1) return; 
	char ind_buffer_1[1024]; // 1st buffer ind block
	char ind_buffer_2[1024]; // 2nd buffer ind block
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET);
	read(fd, ind_buffer_1, sizeof(*ind_buffer_1));

	// Read pointers from indirect block
	for (unsigned int i = 0; i<256; ++i){
		// Read pointer to nested indirection
		lseek(fd, BLOCK_OFFSET(ind_buffer_1[i * 4]), SEEK_SET);
		read(fd, ind_buffer_2, sizeof(*ind_buffer_2));

		for(unsigned int i = 0; i < 256; ++i){

			lseek(fd, BLOCK_OFFSET(ind_buffer_2[i * 4]), SEEK_SET);
			read(fd, buffer, sizeof(*buffer));
			
			// Perform jpg check
			if (buffer[0] == (char)0xff &&
				buffer[1] == (char)0xd8 &&
				buffer[2] == (char)0xff &&
				(buffer[3] == (char)0xe0 ||
				buffer[3] == (char)0xe1 ||
				buffer[3] == (char)0xe8)) {
					is_jpg = 1;
			}
			is_jpg=is_jpg;
		}
		// printf("----------------------\n");
		// printf("------is_jpeg: %d------\n", is_jpg);
		// printf("----------------------\n");
	}
}

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
	char dir_name[537];
	strcpy(dir_name, argv[2]);
	fd = open(argv[1], O_RDONLY);    /* open disk image */

	ext2_read_init(fd);

	struct ext2_super_block super;
	struct ext2_group_desc group;
	
	// example read first the super-block and group-descriptor
	read_super_block(fd, 0, &super);
	read_group_desc(fd, 0, &group);
	
	printf("There are %u inodes in an inode table block and %u blocks in the idnode table\n", inodes_per_block, itable_blocks);
	//iterate the first inode block
	off_t start_inode_table = locate_inode_table(0, &group);
	printf("DEBUG inodes per block: %d\n", inodes_per_block);
	inode_num = -1;
    for (unsigned int i = 0; i < 15; i++) { // TODO: num_groups * inodes_per_group
			inode_num++;
			printf("inode %u: \n", i);
            struct ext2_inode *inode = malloc(sizeof(struct ext2_inode));
			int isReg= -1;
			int isDir=-1;
			// char buffer[1024];
            read_inode(fd, 0, start_inode_table, i, inode);
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
// TODO: while loop to read data from i_size to find num of data blocks??
			// print i_block numberss
			for(unsigned int i=0; i<EXT2_N_BLOCKS; i++)
			{
					int is_jpg = 0;
				    if (i < EXT2_NDIR_BLOCKS) {                                 /* direct blocks */
						printf("Block %2u : %u\n", i, inode->i_block[i]);
						handle_direct_blocks(inode, is_jpg, isReg, i, fd, dir_name);
					}
					else if (i == EXT2_IND_BLOCK){
						printf("Single   : %u\n", inode->i_block[i]); 			/* single indirect block */
						handle_s_in_direct_blocks(inode, is_jpg, isReg, i, fd, dir_fd);
					}                             
					else if (i == EXT2_DIND_BLOCK){                             /* double indirect block */
						printf("Double   : %u\n", inode->i_block[i]);
						handle_d_in_direct_blocks(inode, is_jpg, isReg, i, fd);
					}
					else if (i == EXT2_TIND_BLOCK){                            	/* triple indirect block */
						printf("Triple   : %u\n", inode->i_block[i]);
					}

			}
			
            free(inode);

        }

	
	close(fd);
}
