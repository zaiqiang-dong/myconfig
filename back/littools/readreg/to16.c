#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "string.h"
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <sched.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <ctype.h>
#include <pthread.h>
void main(int argc,char *argv[]) {
	int a = (int)atoi(argv[1]);
	int base = 0x78af000 - 4;
	int i = 0;
	for(i=0; i < a; i++){
		base += 4;
		printf("./r 0x%x",base);
		printf("\n");
	}

}
