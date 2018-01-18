#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <inttypes.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <ctype.h>
#include <sys/ioctl.h>
#include <linux/fb.h>

int str2int(char * str)
{
	char c;
	char *pstr;
	int base;
	int ret = 0; 

	pstr = str;
	do {
		c = *pstr++;
	} while (isspace(c));

	if ('0' == c && 'x' == *pstr) {
		base = 16;
	} else {
		base = 10;
	}

	switch (base) {
		case 10:
			ret = strtoimax(str, NULL, 10);

			break;
		case 16:
			ret = strtoimax(str, NULL, 16);

			break;
		default:
			break;
	}

	return ret;
}

int main(int argc,char *argv[]) {
	printf("Test For Sub Panel\n");	
	int command = 0;
	int arg = 0;
	int fbfd = 0;
	struct fb_var_screeninfo vinfo;
	command = str2int(argv[2]);
	arg = str2int(argv[3]);
	printf("Get command is :%d and arg is :%d for %s\n", command, arg,argv[1]);
	fbfd = open(argv[1], O_RDWR);  
	if (!fbfd) {  
		printf("Error: cannot open framebuffer device.\n");  
		exit(1);  
	}  
	printf("The framebuffer device was opened successfully.\n");  
				  
	// Get variable screen information  
	if (ioctl(fbfd, FBIOGET_VSCREENINFO, &vinfo)) {  
		printf("Error reading variable information.\n");  
	}  

	printf("Dislay is %dx%d, %dbpp\n", vinfo.xres, vinfo.yres, vinfo.bits_per_pixel);  

	switch(command) {
		case 0:
			printf("Command 0 ctl power\n");
			break;
		case 1:
			printf("Command 1 ctl blank\n");
			if (ioctl(fbfd, FBIOBLANK, arg)) {  
				printf("Error reading variable information.\n");  
			}  
			break;
		default:
			printf("Unkown command\n");
			break;
	}
	close(fbfd);
	return 0;
}
