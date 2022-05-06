#include <stdio.h>
#include "ext2_fs.h"
#include "read_ext2.h"
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

// Track inode number
int inode_num = -999;

void handle_direct_blocks(int block_addr, int size, int is_jpg, int isReg, int fd, char dir_name[537]) {
	// Returning if empty block or a dir
	char buffer[1024];
	char inode_name[537];

	// if(inode->i_block[i] == 0 || isReg != 1) return; 
	if(block_addr == 0 || isReg != 1) return; 

	// Seeking to the correct data block
	// lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET); // TODO: Fix for only size of file, not entire block
	lseek(fd, BLOCK_OFFSET(block_addr), SEEK_SET); // TODO: Fix for only size of file, not entire block
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
	
	sprintf(inode_name, "%s/%s%d%s", dir_name, "file-", inode_num, ".jpg"); 
	// sprintf(file_name, "%s/%s", dir_name, "a.jpg"); // TODO: Remove hard coding and retrieve filename
	int file_i = open(inode_name, O_CREAT | O_TRUNC | O_WRONLY, 0666); // TODO: Assert fp is not null??
	// TODO: Check why file empty
	// int byte_read = write(file_i, buffer, sizeof(buffer)); 

	// printf("file size: %d\n", inode->i_size);

	// int num_blocks = inode->i_size / sizeof(buffer);
	int num_blocks = size / sizeof(buffer);
	int written = 0;
	
	if(num_blocks == 0){
		printf("INSIDE\n");
		// for(int b = 0; b < (int) inode->i_size; ++b)
			// write(file_i, buffer, sizeof(buffer));
		// written += write(file_i, buffer, inode->i_size);
		written += write(file_i, buffer, size);
		return;
	}

	// Write out full blocks
	for(int j = 0; j < num_blocks; ++j) written += write(file_i, buffer, sizeof(buffer));
	
	//if there are extra bytes that need to be written (ie, we use a partial block)
	// int bytes_left = inode->i_size - 1024 * num_blocks;
	int bytes_left = size - 1024 * num_blocks;
	
	// // DEBUG OUTPUT
	// printf("------------------------------------------------\n");
	// printf("file size: %u \n", inode->i_size);
	// printf("num_blocks: %d\n", num_blocks);
	// printf("bytes left: %d \n", bytes_left);
	// printf("bytes written: %d\n", written);
	// printf("------------------------------------------------\n");
	// // DEBUG OUTPUT
	
	// lseek(fd, BLOCK_OFFSET(inode->i_block[i]+1024*num_blocks), SEEK_SET);
	lseek(fd, BLOCK_OFFSET(block_addr+1024*num_blocks), SEEK_SET);
	if(bytes_left != 0) write(file_i, buffer, bytes_left);

	printf("num_blocks: %d\n", num_blocks);

	// if not, write out entire block 
	close(file_i);
}

/*
	enter the indirection
	iterate through indirection until null (offset by 4)
	add the data at each pointer into buffer

	do the jpg check
*/

// Call back direct block from within indirection
void handle_s_in_direct_blocks(struct ext2_inode *inode, int is_jpg, int isReg, int i, int fd, char dir_name[537]) {

	int ind_buffer[256]; // buffer ind block as an int
	
	// Read indirect block
	lseek(fd, BLOCK_OFFSET(inode->i_block[i]), SEEK_SET);
	read(fd, ind_buffer, sizeof(ind_buffer));

	// Read pointers from indirect block
	// loop over the int buffer
	for (unsigned int i = 0; i < 256; ++i){

		handle_direct_blocks(ind_buffer[i], inode->i_size, is_jpg, isReg, fd, dir_name);

		// lseek(fd, BLOCK_OFFSET(ind_buffer[i * 4]), SEEK_SET);
		// read(fd, buffer, 1024);

		// // Perform jpg check
		// if (buffer[0] == (char)0xff &&
		// 	buffer[1] == (char)0xd8 &&
		// 	buffer[2] == (char)0xff &&
		// 	(buffer[3] == (char)0xe0 ||
		// 	buffer[3] == (char)0xe1 ||
		// 	buffer[3] == (char)0xe8)) {
		// 		is_jpg = 1;
		// }
		// is_jpg=is_jpg;
		// // printf("----------------------\n");
		// // printf("------is_jpeg: %d------\n", is_jpg);
		// // printf("----------------------\n");
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
    // for (unsigned int i = 0; i < num_groups * inodes_per_group; i++) { // TODO: Is this correct?
    for (unsigned int i = 0; i < 15; i++) { // TODO: Is this correct?
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
						// if(inode->i_links_count == 0 && isReg) printf("-------- DELETED ---------\n");
						// handle_direct_blocks(inode, is_jpg, isReg, i, fd, dir_name);
						handle_direct_blocks((int) inode->i_block[i], (int) inode->i_size, is_jpg, isReg, fd, dir_name);
					}
					else if (i == EXT2_IND_BLOCK){
						printf("Single   : %u size: %d\n", inode->i_block[i], inode->i_size); 			/* single indirect block */
						handle_s_in_direct_blocks(inode, is_jpg, isReg, i, fd, dir_name);

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
