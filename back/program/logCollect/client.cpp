#include <stdio.h>  
#include <sys/types.h>  
#include <sys/socket.h>  
#include <netinet/in.h>  
#include <arpa/inet.h>  
#include <time.h>
#include <sys/stat.h> 
#include <fcntl.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include "nv.h"

#define IMEI_LEN 15
#define LOG_BUF_SIZE 1024

int charArray_to_hexArray(char *input, int inputLen, int start, int len, char *output, int outputLen, int revert) {
    if(inputLen < len || outputLen < len)
        return -1;

    for(int i = 0; i < len; i++) {
        char high = *(input + start + i) / 16;

        if(high >= 10)
            high = 'a' + high - 10;
        else
            high += '0';
        char low = *(input + start + i) % 16;

        if(low >= 10)
            low = 'a' + low - 10;
        else
            low += '0';
        if(revert) {
            *(output + i * 2) = low;
            *(output + i * 2 + 1) = high;
        } else {
            *(output + i * 2) = high;
            *(output + i * 2 + 1) = low;
        }
    }
    return 0;
}
 
int main(int argc, char *argv[])  
{  
    int client_sockfd;  
    int len;  
    char * endoflog = "\n---THEEND---";
    struct sockaddr_in remote_addr; //服务器端网络地址结构体  
    char logBuf[LOG_BUF_SIZE];
    unsigned char tmp[256] = { 0 };
    char format_buf[256] = { 0 };
    char head[32]={'\0'};
    int file = 0;
    int readCnt = 0;
    /* Calling LSM init  */
    if(!Diag_LSM_Init(NULL)) {
        printf("LSM init failed");
        return -1;
    }
    printf("LSM init succeeded\n");

    /* Register the callback for the primary processor */
    register_callback();

    /**Read modem version*/
    diag_send_cmd(DIAG_EXT_BUILD_ID_F, tmp, sizeof(tmp));
    diag_ext_build_id_rsp_type *p_modem_v = (diag_ext_build_id_rsp_type *) tmp;
    printf("modem version=%s \n", p_modem_v->ver_strings);
    memset(format_buf, 0, sizeof(format_buf));
    diag_nv_read(NV_UE_IMEI_I, tmp, sizeof(tmp));
    charArray_to_hexArray((char *) tmp, sizeof(tmp), 4, 8, (char *) format_buf, sizeof(format_buf), 1);
    strlcpy(head, (format_buf + 1), IMEI_LEN + 1);
    *(head + IMEI_LEN) = ':';
    *(head + 16) = '0';
    *(head + 17) = '\n';
    printf("head=%s\n", head);

    printf("The server ip is: %s and port is: %s\n",argv[1],argv[2]);
    memset(&remote_addr,0,sizeof(remote_addr)); //数据初始化--清零  
    remote_addr.sin_family=AF_INET; //设置为IP通信  
    remote_addr.sin_addr.s_addr=inet_addr(argv[1]);//服务器IP地址  
    remote_addr.sin_port=htons(atol(argv[2])); //服务器端口号  
    /*循环的发送接收信息并打印接收信息--recv返回接收到的字节数，send返回发送的字节数*/  
    while(1)  
    { 	
	file = open("/proc/kmsg",O_RDONLY); 
	if(file > 0) {
    	/*创建客户端套接字--IPv4协议，面向连接通信，TCP协议*/  
    	if((client_sockfd=socket(PF_INET,SOCK_STREAM,0))<0)  
    	{  
    	    perror("socket");  
    	    //return 1;  
    	}  
    	/*将套接字绑定到服务器的网络地址上*/  
    	if(connect(client_sockfd,(struct sockaddr *)&remote_addr,sizeof(struct sockaddr))<0)  
    	{  
    	    perror("connect");  
			//return 1;  
    	}  
    	printf("connected to server\n");  

        len=send(client_sockfd,head,strlen(head),0);  
	    do {
	    	readCnt = read(file,logBuf,LOG_BUF_SIZE); 
		printf("readCnt is = %d\n",readCnt);
            	len=send(client_sockfd,logBuf,readCnt,0);  
	    } while (readCnt >= LOG_BUF_SIZE);
	    close(file);
            len=send(client_sockfd,endoflog,strlen(endoflog),0);  
            printf("Send end and goto sleep 5s\n");
	    sleep(5);  
    	    close(client_sockfd);//关闭套接字  
	}else{
	    printf("Open log file faild!\n");
	}
    }  
    close(client_sockfd);//关闭套接字  
    return 0;  
}  


