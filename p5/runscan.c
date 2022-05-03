#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include "ext2_fs.h"
#include "read_ext2.h"

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

    int dir_fd = mkdir(argv[2], 'r');
	int fd;
	fd = open(argv[1], O_RDONLY);    /* open disk image */
	ext2_read_init(fd);

	struct ext2_super_block super;
	struct ext2_group_desc group;
	
	
    /*
        1. go through all the groups
        2. iterate through the inode table
        3. for each inode check if it is a directory or reg file
            3a. jpg check
                i. copy the file into the output directory
            3b. if directory
                i. find file name
                ii. rewrite to output
    */

    unsigned int curr_group = 0;
    for(; curr_group < num_groups; curr_group) {
        
	    // read  current the super-block and group-descriptor
	    read_super_block(fd, curr_group, &super);
	    read_group_desc(fd, curr_group, &group);
        off_t start_inode_table = locate_inode_table(curr_group, &group)

        unsigned int i = 0;
        for(; i < inodes_per_block; i++) {
            struct ext2_inode *inode = malloc(sizeof(struct ext2_inode));
            read_inode(fd, curr_group, start_inode_table, i, inode);

            unsigned int i_blocks = inode->i_blocks/(2<<super.s_log_block_size);

            free(inode);
        }

    }
		
	close(fd);
}
