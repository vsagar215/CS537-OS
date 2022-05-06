#include <stdio.h>
#include "ext2_fs.h"
#include "read_ext2.h"
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

// Track inode number
int inode_num = -999;
// int foobar = 0;

void handle_direct_blocks(int block_addr, int size, int fd, int file_i) {

	char buffer[1024];
	// Returning if empty block
	if(block_addr == 0) return;
	
	// Seeking to the correct data block
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET);
	read(fd, buffer, size);
	write(file_i, buffer, size);
}

// Call back direct block from within indirection
void handle_s_in_direct_blocks(int block_addr, int size, int fd, int file_i){
	
	int ind_buffer[256]; // buffer ind block as an int
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET);
	read(fd, ind_buffer, sizeof(ind_buffer));

	// Read pointers from indirect block
	for (unsigned int i = 0; i < 256; ++i){
		handle_direct_blocks(ind_buffer[i], size, fd, file_i);
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
		handle_s_in_direct_blocks(sec_ind_buffer[i], size, fd, file_i);//is_jpg, isReg, fd, dir_name);
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
			
			if(isDir == 1) continue;

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

			// Create and open file
			sprintf(inode_name, "%s/%s%d%s", dir_name, "file-", inode_num, ".jpg");
			int file_i = open(inode_name, O_CREAT | O_TRUNC | O_WRONLY, 0666); // TODO: Assert fp is not null?
			
			// how many blocks to read
			int num_blocks = inode->i_size / 1024;
			int bytes_left = inode->i_size % 1024;
			int total_bytes = inode->i_size; total_bytes=total_bytes;
			
			for(unsigned int i=0; i<EXT2_N_BLOCKS; i++)
			{
				// TODO: LATER Check if file spans just direct or direct and indirect blocks 
				if (i < EXT2_NDIR_BLOCKS) {                                 /* direct blocks */
					printf("Block %2u : %u\n", i, inode->i_block[i]);				
					if(num_blocks > 0){
						handle_direct_blocks((int) inode->i_block[i], 1024, fd, file_i);
					} else{
						handle_direct_blocks((int) inode->i_block[i], bytes_left, fd, file_i);
					}
				}
				else if (i == EXT2_IND_BLOCK){
					printf("Single   : %u size: %d\n", inode->i_block[i], inode->i_size); 			/* single indirect block */
					if(num_blocks > 0)
						handle_s_in_direct_blocks((int) inode->i_block[i], 1024, fd, file_i);
					else
						handle_s_in_direct_blocks((int) inode->i_block[i], bytes_left, fd, file_i);
				num_blocks--;
				}                             
				else if (i == EXT2_DIND_BLOCK){                             /* double indirect block */
					printf("Double   : %u\n", inode->i_block[i]);
					if(num_blocks > 0)
						handle_d_in_direct_blocks((int) inode->i_block[i], 1024, fd, file_i);
					else
						handle_d_in_direct_blocks((int) inode->i_block[i], bytes_left, fd, file_i);
				}
				else if (i == EXT2_TIND_BLOCK){                            	/* triple indirect block */
					printf("Triple   : %u\n", inode->i_block[i]);
				}
				num_blocks--;
			}
			close(file_i); // TODO: Move it
			free(inode);
		}
	}
	close(fd);
	// printf("Bytes Left: %d\n", foobar);
}