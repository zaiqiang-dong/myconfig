/******************************************************************************
  @file  tests/unit/drivers/qi2c/src/qi2c-eeprom.c
  @brief This is the QI2C eeprom driver unit tests implementation

  This file contains the implementation of the I2C eeprom driver unit tests.
  It is a standalone application that links to the libqi2c-driver library and
  should be run to check the sanity of the eeprom driver.

  -----------------------------------------------------------------------------
  Copyright (c) 2007 QUALCOMM Incorporated.  All Rights Reserved.
  QUALCOMM Proprietary and Confidential.
  -----------------------------------------------------------------------------

 ******************************************************************************/

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
#include <sys/ioctl.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>

#define DATA_SIZE	64
#define ARRAY_SIZE(a)	((sizeof(a) / sizeof(*a)))

static int do_rdwr(int fd, struct i2c_msg *msgs, int nmsgs);
static int read_byte(int fd, unsigned char saddr, uint8_t * buf, int size)
{
	struct i2c_msg msgs[] = {
		[0] = {
			.addr = saddr,
			.flags = 0,
			.buf = buf,
			.len = 1,
		},
		[1] = {
			.addr = saddr,
			.flags = I2C_M_RD,
			.buf = (void *)buf,
			.len = size,
		},
	};

	if (do_rdwr(fd, msgs, ARRAY_SIZE(msgs))) {
		printf("failed do rdwr i2c!\n");
		return -1;
	}

	return 0;
}

static int write_byte(int fd, unsigned char saddr, unsigned char raddr, unsigned char data)
{
	unsigned char buf[8];

	buf[0] = raddr;
	buf[1] = data;

	struct i2c_msg msgs[] = {
		[0] = {
			.addr = saddr,
			.flags = 0,
			.buf = buf,
			.len = 2,
		},
	};

	if (do_rdwr(fd, msgs, ARRAY_SIZE(msgs))) {
		printf("failed do rdwr i2c!\n");
		return -1;
	}

	return 0;
}

static void signal_hander(int data)
{
	kill(getpid(), 9);
}

void usage(char *argv[])
{
	printf("Usage: %s [options] slave_addr reg_addr\n", argv[0]);
	printf("           slave_addr - decimal num or hex num\n");
	printf("           reg_addr - decimal num or hex num\n\n");
	printf("       -b  -> specify I2C bus number 0 | 1, default is 0\n");
	printf("       -c  -> clear(0x0) the target register after read\n");
	printf("       -l  -> operate in loop\n");
	printf("       -d  -> delay 1 second each time, work for operating in loop\n");
	printf("       -w  -> switch to write mode, default is read\n");
	printf("       -h  -> help\n");
	printf("       -t time  -> delay with specific interval time, work for operating in loop\n");
	printf("\n");
	printf("       eg: %s 0x30 0xa\n", argv[0]);
	printf("       eg: %s 48 10\n\n", argv[0]);
	printf("       eg: %s -l 48 10 \n", argv[0]);
	printf("       eg: %s -l -d 0x30 0xa\n", argv[0]);
	printf("       eg: %s -l -t 3 0x30 0xa\n", argv[0]);
	printf("\n");
	exit(EXIT_FAILURE);
}

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

int main(int argc, char * argv[]) 
{
	char dev_file[64];
	uint8_t read_buf[DATA_SIZE];
	//uint8_t write_buf[DATA_SIZE];
	uint8_t saddr;
	uint16_t raddr;
	uint8_t data;
	int c;
	int fd, help = 0;
	int rc = 0;
	int loop = 0;
	int version = 0;
	int read = 1;
	int delay = 0;
	int delay_time = 1;	//second
	int clear = 0;
	int bus_num = 0;

	signal(SIGINT, signal_hander);
	signal(SIGQUIT, signal_hander);

	while ((c = getopt(argc, argv, "b:cdhlt:wv")) != -1) {
		switch (c) {
			case 'b':
				bus_num = atoi(optarg);
				break;
			case 'c':
				clear = 1;
				break;
			case 'd':
				delay = 1;
				break;
			case 'h':
				help = 1;
				break;
			case 'l':
				loop = 1;
				break;
			case 't':
				delay = 1;
				delay_time = str2int(optarg);
				break;
			case 'w':
				read = 0;
				break;
			case 'v':
				version = 1;
				break;
			default:
				break;
		}
	}

	if (version) {
		printf("Version: %s - %s\n\n", __DATE__, __TIME__);
		return 0;
	}

	if(argc < 3 || help) {
		usage(argv);

		return -1;
	}
#if 0
	if (argc == 4) {
		loop = 1;
	}
	if (argc == 5) {
		read = 0;
	}
	if (argc == 6) {
		loop = 1;
		read = 0;
	}
#endif

	snprintf(dev_file, 64, "%s%d", "/dev/i2c-", bus_num);

	fd = open(dev_file, O_RDWR);
	if (fd < 0) {
		rc = -1;
		fprintf(stderr, "Could not open file node /dev/i2c-0\n");
		goto err_open;
	}
	printf("Opened bus device: %s\n", dev_file);

	saddr = str2int(argv[optind]);
	raddr = str2int(argv[optind + 1]);

	do {
		if (read) {
			read_buf[0] = raddr;
			printf("try to read: slave addr - 0x%x, reg addr - 0x%x, val - 0x%x \n", 
					saddr, 
					raddr, 
					read_buf[0]);
			if (0 == read_byte(fd, saddr, &read_buf[0], 1))
			{
				printf("[read back]: slave addr - 0x%x, reg addr - 0x%x, val - 0x%x \n", 
						saddr, 
						raddr, 
						read_buf[0]);
			}

			if (clear) {
				data = 0x0;
				if (0 == write_byte(fd, saddr, raddr, data)) {
					printf("write success!\n");
				}
			}
		} else {
			data = str2int(argv[optind + 2]);
			printf("try to write: slave addr - 0x%x, reg addr - 0x%x, val - 0x%x \n", 
					saddr, 
					raddr, 
					data);
			if (0 == write_byte(fd, saddr, raddr, data)) {
				printf("write success!\n");
			}
		}

		if (delay) {
			sleep(delay_time);
		}
	} while(loop);

err_read1:
	close(fd);
err_open:
	return rc;
}

static int do_rdwr(int fd, struct i2c_msg *msgs, int nmsgs) 
{
	int ret = 0;
	struct i2c_rdwr_ioctl_data msgset = {
		.msgs = msgs,
		.nmsgs = nmsgs,
	};

	if (NULL == msgs || nmsgs <= 0) {
		return -1;
	}

	if ((ret = ioctl(fd, I2C_RDWR, &msgset)) < 0) {
		printf("failed to ioctl I2C_RDWR! ret = %d\n", ret);
		return -1;
	}

	return 0;
}
