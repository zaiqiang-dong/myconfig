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
#include <hardware_legacy/power.h>

#define FALSE  -1
#define TRUE   0
#define BUFFSIZE 1024
//#define BUFFSIZE 4096
char version[] = "V1.0.0";


/*********************************************************************/
int OpenDev(char *Dev)
{
    int fd = open( Dev, O_RDWR | O_NOCTTY);         //| O_NOCTTY | O_NDELAY    
    if (-1 == fd)   
    {           
        perror("Can't Open Serial Port");
        return -1;      
    }   
    else    
    return fd;
}
/**
*/
int speed_arr[] = {B3500000,B460800,B115200,B38400, B19200, B9600, B4800, B2400, B1200, B300,
                   B38400, B19200, B9600, B4800, B2400, B1200, B300, };
int name_arr[] = {3500000,460800,115200,38400,  19200,  9600,  4800,  2400,  1200,  300, 38400,
                  19200,  9600, 4800, 2400, 1200,  300, };
void set_speed(int fd, int speed)
{
    int   i; 
    int   status; 
    struct termios   Opt;
    tcgetattr(fd, &Opt); 
    for ( i= 0;  i < (int)(sizeof(speed_arr) / sizeof(int));  i++) { 
        if  (speed == name_arr[i]) {     
            tcflush(fd, TCIOFLUSH);     
            cfsetispeed(&Opt, speed_arr[i]);  
            cfsetospeed(&Opt, speed_arr[i]);   
            status = tcsetattr(fd, TCSANOW, &Opt);  
            if  (status != 0) {        
                perror("tcsetattr fd1");  
                return;     
            }    
            tcflush(fd,TCIOFLUSH);   
        }  
    }
}
/**
*/
int set_Parity(int fd,int databits,int stopbits,int parity,int flow_ctrl)
{ 
    struct termios options; 
	int i;
	char *p;

    if  ( tcgetattr( fd,&options)  !=  0) { 
        perror("SetupSerial 1");     
        return(FALSE);  
    }
		printf("------------start------------------\n");
		p = &options;
	for (i = 0; i < sizeof(struct termios); i++)	
	{
		if(i%4 == 0)
			printf("\n%d: ", i);
		printf(" %02x", *(p+i));
	}
			printf("\n ");
		printf("------------end------------------\n");
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    options.c_oflag &= ~OPOST;
    options.c_cflag &= ~CSIZE;         
    //options.c_cflag |= (CLOCAL | CREAD);          
    options.c_oflag &= ~(ONLCR | OCRNL); 
    options.c_iflag &= ~(ICRNL | INLCR);     
    options.c_iflag &= ~(IXON | IXOFF | IXANY);
    switch (databits) /**/
    {   
        case 7:     
        options.c_cflag |= CS7; 
        break;
        case 8:     
        options.c_cflag |= CS8;
        break;   
        default:    
        fprintf(stderr,"Unsupported data size\n"); return (FALSE);  
    }
    switch (parity) 
    {   
        case 'n':
        case 'N':    
        options.c_cflag &= ~PARENB;   /* Clear parity enable */
        options.c_iflag &= ~INPCK;     /* Enable parity checking */ 
        break;  
        case 'o':   
        case 'O':     
        options.c_cflag |= (PARODD | PARENB); /* 2019*/  
        options.c_iflag |= INPCK;             /* Disnable parity checking */ 
        break;  
        case 'e':  
        case 'E':   
        options.c_cflag |= PARENB;     /* Enable parity */    
        options.c_cflag &= ~PARODD;   /* */     
        options.c_iflag |= INPCK;       /* Disnable parity checking */
        break;
        case 'S': 
        case 's':  /*as no parity*/   
        options.c_cflag &= ~PARENB;
        options.c_cflag &= ~CSTOPB;break;  
        default:   
        fprintf(stderr,"Unsupported parity\n");    
        return (FALSE);  
    }  
	switch (stopbits)
	{   
	    case 1:    
	    options.c_cflag &= ~CSTOPB;  
	    break;  
	    case 2:    
	    options.c_cflag |= CSTOPB;  
	    break;
	    default:    
	    fprintf(stderr,"Unsupported stop bits\n");  
	    return (FALSE); 
	} 
	switch(flow_ctrl)
	{
		case 0 : //
		options.c_cflag &= ~CRTSCTS;
		break;    
		case 1 : //
		options.c_cflag |= CRTSCTS;
		break;
		case 2 : //
		options.c_cflag |= IXON | IXOFF | IXANY;
		break;
	}
	/* Set input parity option */ 
	if (parity != 'n')   
	options.c_iflag |= INPCK; 
	tcflush(fd,TCIFLUSH);
	options.c_cc[VTIME] = 1; 
	options.c_cc[VMIN] = 0; 
	if (tcsetattr(fd,TCSANOW,&options) != 0)   
	{ 
	    perror("SetupSerial 3");   
	    return (FALSE);  
	} 
		printf("------2------start------------------\n");
	for (i = 0; i < sizeof(struct termios); i++)	
	{
		if(i%4 == 0)
			printf("\n%d: ", i);
		//if(i == 13)
	//		*(p + 13) = 0x8a;
		printf(" %02x", *(p+i));
	}
			printf("\n ");
		printf("------2------end------------------\n");

	return (TRUE);  
}


int main(int argc,char *argv[])
{
	printf("Version is: %s\n",version);
	int send_len = 0;
	int recive_len = 0;
	int send_all = 0;
	int recive_all = 0;
	struct sched_param param; 
	int maxpri; 
	maxpri = sched_get_priority_max(SCHED_FIFO);
	if(maxpri == -1) 
	{ 
        printf("sched_get_priority_max() failed"); 
        return 0; 
    } 
	else
	{
		printf("the priorty is : %d \n",maxpri);
	}
    param.sched_priority = maxpri; 
    if (sched_setscheduler(getpid(), SCHED_FIFO, &param) == -1) 
    { 
        printf("sched_setscheduler() failed"); 
        return 0;
    } 
    int fd;
    char *buff = (char *)malloc(BUFFSIZE);
    char *dev  =  argv[1]; 
    int com_speed = (int)atoi(argv[2]);
	int is_revice = (int)atoi(argv[3]);
	int byte_num  = (int)atoi(argv[4]);
	int flow_contral  = (int)atoi(argv[5]);
	int check_end = 0;
	//int sleepus = (1000000/((com_speed/10)/5)) + 1;
	int sleepus  = (int)atoi(argv[6]);
    printf("The interval is:%dus\n",sleepus);
    fd = OpenDev(dev);
    if(-1 == fd)
    {
        printf("Open %s Error,and exit\n",dev);
        return 0;
    }
    set_speed(fd,com_speed);
    if (set_Parity(fd,8,1,'N',flow_contral) == FALSE)  
    {
        printf("Set Parity Error\n");
        goto exit_1;
    }

	if(is_revice == 0) {
		while (1) 
		{
			//printf("[gps_data_ops]:get data from serail!.\n");
			recive_len = read(fd, buff, BUFFSIZE);
			if (recive_len > 0) 
			{
				check_end = 0;
				recive_all += recive_len;
				*(buff+recive_len) = '\0';
				printf("[data]:%s.",buff);
				printf("[count]:%d.\n",recive_all);
				
			} else {
				check_end++;
				if(check_end >= 50)
					break;
			}
    	}
	} else {
		while (1) 
		{
			//printf("[gps_data_ops]:get data from serail!.\n");
			send_len = write(fd,"ABCDE", 5);
			if (send_len > 0) 
			{
				byte_num -= send_len;
				send_all += send_len;
				printf("[send]:%s.","ABCDE");
				printf("[count]:%d.\n",send_all);
				if(byte_num <= 0)
					goto exit_1;
				
			}

			usleep(sleepus);
    	}

	}
exit_1:
	printf("Test end!");
	close(fd); 
    return 0;
}



