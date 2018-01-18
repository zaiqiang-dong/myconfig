#include <linux/device.h>
#include <linux/kernel.h>
#include <linux/i2c.h>
#include <linux/input.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/of_irq.h>
#include <linux/gpio.h>
#include <linux/miscdevice.h>
#include <linux/interrupt.h>
#include <linux/delay.h>
#include <linux/firmware.h>
#include <linux/platform_device.h>
#include <linux/workqueue.h>
#include <linux/slab.h>
#include <linux/fs.h>
#include <linux/proc_fs.h>
#include <linux/uaccess.h>
#include <asm/io.h>
#include <linux/init.h>
#include <linux/pci.h>
#include <linux/of_device.h>
#include <linux/of_gpio.h>
#include <linux/dma-mapping.h>
#include <linux/gameport.h>
#include <linux/moduleparam.h>
#include <linux/mutex.h>
#include <linux/module.h>
#include <linux/wakelock.h>
#include <linux/atomic.h>
#include "aw9120_reg.h"
// Add begin by ODM.jianghangxing for: aw9120 led driver
#include <linux/jiffies.h>
#include <linux/leds.h>
#include <linux/cdev.h>
#include <linux/debugfs.h>
#include <asm/errno.h>
#include <linux/of_platform.h>
#include <linux/spmi.h>
#include <linux/regulator/consumer.h>
#include <linux/sysfs.h>
// Add end

//////////////////////////////////////
// Marco
//////////////////////////////////////
#define AW9120_LED_NAME     "aw9120_led"

//////////////////////////////////////
// i2c client
//////////////////////////////////////

struct aw9120_chip {
	struct i2c_client *client;
	struct pinctrl *aw9120ctrl;
	struct pinctrl_state *aw9120_pdn_high;
	struct pinctrl_state *aw9120_pdn_low;
// Add begin by ODM.jianghangxing for: aw9120 led driver
	struct led_classdev cdev_red1;
	struct led_classdev cdev_red2;
	struct led_classdev cdev_red3;
	struct led_classdev cdev_red4;
	struct led_classdev cdev_red5;
	struct led_classdev cdev_green1;
	struct led_classdev cdev_green2;
	struct led_classdev cdev_green3;
	struct led_classdev cdev_green4;
	struct led_classdev cdev_green5;
	struct led_classdev cdev_blue1;
	struct led_classdev cdev_blue2;
	struct led_classdev cdev_blue3;
	struct led_classdev cdev_blue4;
	struct led_classdev cdev_blue5;
// Add end
	int pdn_gpio;
};

static struct aw9120_chip *chip = NULL;

/* The definition of each time described as shown in figure.
 *        /-----------\
 *       /      |      \
 *      /|      |      |\
 *     / |      |      | \-----------
 *       |hold_time_ms |      |
 *       |             |      |
 * rise_time_ms  fall_time_ms |
 *                       off_time_ms
 */
#define ROM_CODE_MAX 255

/*
 * rise_time_ms = 1500
 * hold_time_ms = 500
 * fall_time_ms = 1500
 * off_time_ms = 1500
 */

// Delete begin by ODM.jianghangxing for: aw9120 driver
//int led_code_len = 7;
//int led_code[ROM_CODE_MAX] = {
//  0xbf00,0x9f05,0xfffa,0x3c7d,0xdffa,0x3cbb,0x2,
//};
// Delete end

// Add begin by ODM.jianghangxing for: aw9120 driver
static int ctrl_pdn_flag = 0;
int led_code_len_led_brights = 1;
int led_code_red1_brights[ROM_CODE_MAX] = {
	0xa000,
};
int led_code_green1_brights[ROM_CODE_MAX] = {
	0xa100,
};
int led_code_blue1_brights[ROM_CODE_MAX] = {
	0xa200,
};
int led_code_red2_brights[ROM_CODE_MAX] = {
	0xa300,
};
int led_code_green2_brights[ROM_CODE_MAX] = {
	0xa400,
};
int led_code_blue2_brights[ROM_CODE_MAX] = {
	0xa500,
};
int led_code_red3_brights[ROM_CODE_MAX] = {
	0xa600,
};
int led_code_green3_brights[ROM_CODE_MAX] = {
	0xa700,
};
int led_code_blue3_brights[ROM_CODE_MAX] = {
	0xa800,
};
int led_code_red4_brights[ROM_CODE_MAX] = {
	0xa900,
};
int led_code_green4_brights[ROM_CODE_MAX] = {
	0xaa00,
};
int led_code_blue4_brights[ROM_CODE_MAX] = {
	0xab00,
};
int led_code_red5_brights[ROM_CODE_MAX] = {
	0xac00,
};
int led_code_green5_brights[ROM_CODE_MAX] = {
	0xad00,
};
int led_code_blue5_brights[ROM_CODE_MAX] = {
	0xae00,
};
//Add end



//////////////////////////////////////////////////////////////////////////////////////////
// PDN power control
//////////////////////////////////////////////////////////////////////////////////////////

// Delete begin by ODM.jianghangxing for: aw9120 driver
/*
int aw9120_gpio_init(void)
{
    int ret = 0;
    struct i2c_client *client = chip->client;

    chip->aw9120ctrl = devm_pinctrl_get(&client->dev);
    if (IS_ERR(chip->aw9120ctrl)) {
        ret = PTR_ERR(chip->aw9120ctrl);
        printk("%s devm_pinctrl_get fail!\n", __func__);
    }
    chip->aw9120_pdn_high = pinctrl_lookup_state(chip->aw9120ctrl, "aw9120_pdn_high");
    if (IS_ERR(chip->aw9120_pdn_high)) {
        ret = PTR_ERR(chip->aw9120_pdn_high);
        printk("%s : pinctrl err, aw9120_pdn_high\n", __func__);
    }

    chip->aw9120_pdn_low = pinctrl_lookup_state(chip->aw9120ctrl, "aw9120_pdn_low");
    if (IS_ERR(chip->aw9120_pdn_low)) {
        ret = PTR_ERR(chip->aw9120_pdn_low);
        printk("%s : pinctrl err, aw9120_pdn_low\n", __func__);
    }

    printk("%s success\n", __func__);
    return ret;
}

static void aw9120_hw_on(void)
{
    printk("%s enter\n", __func__);
    pinctrl_select_state(chip->aw9120ctrl, chip->aw9120_pdn_low);
    msleep(5);
    pinctrl_select_state(chip->aw9120ctrl, chip->aw9120_pdn_high);
    msleep(5);
    printk("%s out\n", __func__);
}

#if 0
static void aw9120_hw_off(void)
{
    printk("%s enter\n", __func__);
    pinctrl_select_state(aw9120ctrl, aw9120_pdn_low);
    msleep(5);
    printk("%s out\n", __func__);
}
#endif
*/
// Delete end

//////////////////////////////////////////////////////////////////////////////////////////
// i2c write and read
//////////////////////////////////////////////////////////////////////////////////////////
unsigned int i2c_write_reg(struct i2c_client *client, unsigned char addr, unsigned int reg_data)
{
	int ret;
	u8 wdbuf[512] = {0};

	struct i2c_msg msgs[] = {
		{
			.addr = client->addr,
			.flags = 0,
			.len = 3,
			.buf = wdbuf,
		},
	};

	if(NULL == client) {
		pr_err("msg %s aw9120_i2c_client is NULL\n", __func__);
		return -1;
	}

	wdbuf[0] = addr;
	wdbuf[2] = (unsigned char)(reg_data & 0x00ff);
	wdbuf[1] = (unsigned char)((reg_data & 0xff00)>>8);

	ret = i2c_transfer(client->adapter, msgs, 1);
	if (ret < 0)
		pr_err("msg %s i2c read error: %d\n", __func__, ret);

	return ret;
}


unsigned int i2c_read_reg(struct i2c_client *client, unsigned char addr)
{
	int ret;
	u8 rdbuf[512] = {0};
	unsigned int getdata;

	struct i2c_msg msgs[] = {
		{
			.addr = client->addr,
			.flags = 0,
			.len = 1,
			.buf = rdbuf,
		},
		{
			.addr = client->addr,
			.flags = I2C_M_RD,
			.len = 2,
			.buf = rdbuf,
		},
	};

	if(NULL == client) {
		pr_err("msg %s aw9120_i2c_client is NULL\n", __func__);
		return -1;
	}

	rdbuf[0] = addr;

	ret = i2c_transfer(client->adapter, msgs, 2);
	if (ret < 0)
		pr_err("msg %s i2c read error: %d\n", __func__, ret);

	getdata=rdbuf[0] & 0x00ff;
	getdata<<= 8;
	getdata |=rdbuf[1];

	return getdata;
}


//////////////////////////////////////////////////////////////////////////////////////////
// aw9120 led
//////////////////////////////////////////////////////////////////////////////////////////
// Delete begin by ODM.jianghangxing for: aw9120 driver
/*
void aw9120_led_off(struct i2c_client *client)
{
    //Disable LED Module
    int err;
    unsigned int reg;
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }

    mdelay(5);
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }

    reg = i2c_read_reg(client, GCR);
    reg &= 0xFFFE;
    i2c_write_reg(client, GCR, reg);        // GCR-Disable LED Module
}
*/
// Delete end

// Add begin by ODM.jianghangxing for: aw9120 driver
static void aw9120_reset(struct aw9120_chip *led)
{
	int err;
	unsigned int reg;

	ctrl_pdn_flag = 1;
	/*硬件重启此时所有的内部寄存器都会reset*/
	err = gpio_direction_output(chip->pdn_gpio, 0);
	if (err) {
		dev_err(&led->client->dev, "unable to set direction for gpio %d\n",
		        chip->pdn_gpio);
	}
	err = gpio_direction_output(chip->pdn_gpio, 1);
	if (err) {
		dev_err(&led->client->dev, "unable to set direction for gpio %d\n",
		        chip->pdn_gpio);
	}
	mdelay(5);

	reg = i2c_read_reg(led->client, GCR);
	reg &= 0xFFFE;
	i2c_write_reg(led->client, GCR, reg);               // GCR-Disable LED Module

	//LED Config
	i2c_write_reg(led->client, IMAX1, 0x1111);          // IMAX1-LED1~LED4 Current
	i2c_write_reg(led->client, IMAX2, 0x1111);          // IMAX2-LED5~LED8 Current
	i2c_write_reg(led->client, IMAX3, 0x1111);          // IMAX3-LED9~LED12 Current
	i2c_write_reg(led->client, IMAX4, 0x1111);          // IMAX4-LED13~LED16 Current
	i2c_write_reg(led->client, IMAX5, 0x1111);          // IMAX5-LED17~LED20 Current
	i2c_write_reg(led->client, LER1, 0x0FFF);           // LER1-LED1~LED12 Enable
	i2c_write_reg(led->client, LER2, 0x00FF);           // LER2-LED13~LED20 Enable
	i2c_write_reg(led->client, CTRS1, 0x0000);          // CTRS1-LED1~LED12: SRAM Control
	i2c_write_reg(led->client, CTRS2, 0x0000);          // CTRS2-LED13~LED20: SRAM Control

	//Enable LED Module
	reg |= 0x0001;
	i2c_write_reg(led->client, GCR, reg);               // GCR-Enable LED Module
}

static void aw9120_red1_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);        // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);        // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);      // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_red1_brights[0] &= 0xff00;
		led_code_red1_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_red1_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_green1_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_green1_brights[0] &= 0xff00;
		led_code_green1_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_green1_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_blue1_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_blue1_brights[0] &= 0xff00;
		led_code_blue1_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_blue1_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_red2_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_red2_brights[0] &= 0xff00;
		led_code_red2_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_red2_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_green2_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_green2_brights[0] &= 0xff00;
		led_code_green2_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_green2_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_blue2_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_blue2_brights[0] &= 0xff00;
		led_code_blue2_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_blue2_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_red3_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_red3_brights[0] &= 0xff00;
		led_code_red3_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_red3_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_green3_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_green3_brights[0] &= 0xff00;
		led_code_green3_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_green3_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_blue3_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_blue3_brights[0] &= 0xff00;
		led_code_blue3_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_blue3_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_red4_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_red4_brights[0] &= 0xff00;
		led_code_red4_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA,led_code_red4_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_green4_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_green4_brights[0] &= 0xff00;
		led_code_green4_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_green4_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_blue4_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_blue4_brights[0] &= 0xff00;
		led_code_blue4_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_blue4_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_red5_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_red5_brights[0] &= 0xff00;
		led_code_red5_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_red5_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_green5_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_green5_brights[0] &= 0xff00;
		led_code_green5_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_green5_brights[i]);
		}
		i2c_write_reg(led->client, WDATA, 0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

static void aw9120_blue5_brights(struct led_classdev *led_cdev, enum led_brightness value)
{
	int i;
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client, PMD, 0x0000);                // PMR-Load SRAM with I2C
	i2c_write_reg(led->client, RMD, 0x0000);                // RMR-Hold Mode
	i2c_write_reg(led->client, WADDR, 0x0000);              // WADDR-SRAM Load Addr

	if (value > 255 || value < 0) {
		;
	} else {
		led_code_blue5_brights[0] &= 0xff00;
		led_code_blue5_brights[0] |= value;

		for(i=0; i<led_code_len_led_brights; i++) {
			i2c_write_reg(led->client, WDATA, led_code_blue5_brights[i]);
		}
		i2c_write_reg(led->client,WDATA,0x0000);

		// LED SRAM Run
		i2c_write_reg(led->client, SADDR, 0x0000);              // SADDR-SRAM Run Start Addr:0
		i2c_write_reg(led->client, PMD, 0x0001);                // PMR-Reload and Excute SRAM
		i2c_write_reg(led->client, RMD, 0x0002);                // RMR-Run
	}
}

// Add begin by ODM.jianghangxing for: aw9120 driver
static ssize_t blink_red1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe0ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc0ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_green1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe1ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc1ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_blue1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue1);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe2ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc2ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}
static ssize_t blink_red2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe3ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc3ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_green2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe4ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc4ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_blue2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue2);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe5ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc5ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_red3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe6ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc6ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_green3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe7ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc7ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_blue3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue3);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe8ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc8ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_red4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xe9ff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xc9ff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_green4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xeaff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xcaff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_blue4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue4);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xebff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xcbff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_red5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_red5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xecff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xccff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_green5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_green5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xedff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xcdff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

static ssize_t blink_blue5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct led_classdev *led_cdev = dev_get_drvdata(dev);
	struct aw9120_chip *led = container_of(led_cdev, struct aw9120_chip, cdev_blue5);

	if (ctrl_pdn_flag == 0) {
		aw9120_reset(led);
	}

	// LED SRAM Hold Mode
	i2c_write_reg(led->client,PMD,0x0000);          // PMR-Load SRAM with I2C
	i2c_write_reg(led->client,RMD,0x0000);          // RMR-Hold Mode

	// Load LED SRAM
	i2c_write_reg(led->client,WADDR,0x0000);                // WADDR-SRAM Load Addr
	i2c_write_reg(led->client, WDATA, 0x803f);
	i2c_write_reg(led->client, WDATA, 0xeeff);              //led1 fade-out step:FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client, WDATA, 0xceff);              //led1 fade-in step: FF
	i2c_write_reg(led->client, WDATA, 0x3cff);              //等待一段时间
	i2c_write_reg(led->client,WDATA, 0x0000);               //跳转。

	// LED SRAM Run
	i2c_write_reg(led->client,SADDR,0x0000);                // SADDR-SRAM Run Start Addr:0
	i2c_write_reg(led->client,PMD,0x0001);          // PMR-Reload and Excute SRAM
	i2c_write_reg(led->client,RMD,0x0002);          // RMR-Run

	return count;
}

// Add end

// Delete begin by ODM.jianghangxing for: aw9120 led driver
/*
void aw9120_led_on(struct i2c_client *client)
{
    //Disable LED Module
    unsigned int reg;
    int err;
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }

    mdelay(5);
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }
    reg = i2c_read_reg(client, GCR);
    reg &= 0xFFFE;
    i2c_write_reg(client, GCR, reg);        // GCR-Disable LED Module

    //LED Config
    i2c_write_reg(client, IMAX1,0x1111);        // IMAX1-LED1~LED4 Current
    i2c_write_reg(client, IMAX2,0x1111);        // IMAX2-LED5~LED8 Current
    i2c_write_reg(client, IMAX3,0x1111);        // IMAX3-LED9~LED12 Current
    i2c_write_reg(client, IMAX4,0x1111);        // IMAX4-LED13~LED16 Current
    i2c_write_reg(client, IMAX5,0x1111);        // IMAX5-LED17~LED20 Current
    i2c_write_reg(client, LER1,0x0FFF);     // LER1-LED1~LED12 Enable
    i2c_write_reg(client, LER2,0x00FF);     // LER2-LED13~LED20 Enable
    //i2c_write_reg(client, CTRS1,0x0FFF);      // CTRS1-LED1~LED12: i2c Control
    //i2c_write_reg(client, CTRS2,0x00FF);      // CTRS2-LED13~LED20: i2c Control
    //i2c_write_reg(client, CMDR,0xBFFF);       // CMDR-LED1~LED20 PWM=0xFF

    //Enable LED Module
    reg |= 0x0001;
    i2c_write_reg(client, GCR,reg);     // GCR-Enable LED Module

    printk("led on ok\n");
}

void aw9120_led_breath(struct i2c_client *client)
{
    //Disable LED Module
    int i;
    unsigned int reg;
    int err;
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }

    mdelay(5);
    err = gpio_direction_output(chip->pdn_gpio, 1);
    if (err) {
        dev_err(&client->dev, "unable to set direction for gpio %d\n",
        chip->pdn_gpio);
    }
    reg = i2c_read_reg(client,GCR);
    reg &= 0xFFFE;
    i2c_write_reg(client,GCR, reg);        // GCR-Disable LED Module

    //LED Config
    i2c_write_reg(client,IMAX1,0x1111);     // IMAX1-LED1~LED4 Current
    i2c_write_reg(client,IMAX2,0x1111);     // IMAX2-LED5~LED8 Current
    i2c_write_reg(client,IMAX3,0x1111);     // IMAX3-LED9~LED12 Current
    i2c_write_reg(client,IMAX4,0x1111);     // IMAX4-LED13~LED16 Current
    i2c_write_reg(client,IMAX5,0x1111);     // IMAX5-LED17~LED20 Current
    i2c_write_reg(client,LER1,0x0FFF);  // LER1-LED1~LED12 Enable
    i2c_write_reg(client,LER2,0x00FF);  // LER2-LED13~LED20 Enable
    i2c_write_reg(client,CTRS1,0x0000);     // CTRS1-LED1~LED12: SRAM Control
    i2c_write_reg(client,CTRS2,0x0000);     // CTRS2-LED13~LED20: SRAM Control

    //Enable LED Module
    reg |= 0x0001;
    i2c_write_reg(client,GCR,reg);         // GCR-Enable LED Module

    // LED SRAM Hold Mode
    i2c_write_reg(client,PMR,0x0000);        // PMR-Load SRAM with I2C
    i2c_write_reg(client,RMR,0x0000);        // RMR-Hold Mode

    // Load LED SRAM
    i2c_write_reg(client,WADDR,0x0000);        // WADDR-SRAM Load Addr
    for(i=0; i<led_code_len; i++)
    {
        i2c_write_reg(client,WDATA,led_code[i]);
    }

    // LED SRAM Run
    i2c_write_reg(client,SADDR,0x0000);        // SADDR-SRAM Run Start Addr:0
    i2c_write_reg(client,PMR,0x0001);        // PMR-Reload and Excute SRAM
    i2c_write_reg(client,RMR,0x0002);        // RMR-Run
}
*/
// Delete end

//////////////////////////////////////////////////////////////////////////////////////////
// adb shell
//////////////////////////////////////////////////////////////////////////////////////////
// Delete begin by ODM.jianghangxing for: aw9120 led driver
/*
static ssize_t aw9120_show_debug(struct device* cd,struct device_attribute *attr, char* buf);
static ssize_t aw9120_store_debug(struct device* cd, struct device_attribute *attr,const char* buf, size_t len);
static ssize_t aw9120_get_reg(struct device* cd,struct device_attribute *attr, char* buf);
static ssize_t aw9120_write_reg(struct device* cd, struct device_attribute *attr,const char* buf, size_t len);

static DEVICE_ATTR(debug, 0664, aw9120_show_debug, aw9120_store_debug);
static DEVICE_ATTR(reg, 0664, aw9120_get_reg, aw9120_write_reg);

static ssize_t aw9120_show_debug(struct device* cd,struct device_attribute *attr, char* buf)
{
    ssize_t len = 0;
    len += snprintf(buf+len, PAGE_SIZE-len, "aw9120_led_off(void)\n");
    len += snprintf(buf+len, PAGE_SIZE-len, "echo 0 > debug\n");
    len += snprintf(buf+len, PAGE_SIZE-len, "aw9120_led_on(void)\n");
    len += snprintf(buf+len, PAGE_SIZE-len, "echo 1 > debug\n");
    len += snprintf(buf+len, PAGE_SIZE-len, "aw9120_led_breath(void)\n");
    len += snprintf(buf+len, PAGE_SIZE-len, "echo 2 > debug\n");

    return len;
}

static ssize_t aw9120_store_debug(struct device* cd, struct device_attribute *attr, const char* buf, size_t len)
{
    unsigned int databuf[1];

    sscanf(buf,"%d",&databuf[0]);
    if(databuf[0] == 0) {                               // OFF
        aw9120_led_off(chip->client);
    } else if(databuf[0] == 1){                         // ON
        aw9120_led_on(chip->client);
    } else if(databuf[0] == 2){                         // Breath
        aw9120_led_breath(chip->client);
    } else {
        aw9120_led_off(chip->client);
    }

    return len;
}

static ssize_t aw9120_get_reg(struct device* cd,struct device_attribute *attr, char* buf)
{
    unsigned int reg_val[1];
    ssize_t len = 0;
    unsigned char i;
    for(i=1;i<0x7F;i++) {
        reg_val[0] = i2c_read_reg(chip->client,i);
        len += snprintf(buf+len, PAGE_SIZE-len, "reg%2X = 0x%4X, ", i,reg_val[0]);
    }
    len += snprintf(buf+len, PAGE_SIZE-len, "\n");
    return len;
}

static ssize_t aw9120_write_reg(struct device* cd, struct device_attribute *attr, const char* buf, size_t len)
{
    unsigned int databuf[2];
    if(2 == sscanf(buf,"%x %x",&databuf[0], &databuf[1])) {
        i2c_write_reg(chip->client,(u8)databuf[0],databuf[1]);
    }
    return len;
}

static int aw9120_create_sysfs(struct i2c_client *client)
{
    int err;
    struct device *dev = &(client->dev);

    printk("%s", __func__);

    err = device_create_file(dev, &dev_attr_debug);
    err = device_create_file(dev, &dev_attr_reg);
    return err;
}
*/
// Delete end

// Add begin by ODM.jianghangxing for: aw9120 driver
static ssize_t blink_red1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_red2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_red3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_red4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_red5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_green1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_green2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_green3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_green4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_green5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_blue1_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_blue2_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_blue3_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_blue4_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t blink_blue5_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);

static DEVICE_ATTR(blink_red1, 0664, NULL, blink_red1_store);
static DEVICE_ATTR(blink_red2, 0664, NULL, blink_red2_store);
static DEVICE_ATTR(blink_red3, 0664, NULL, blink_red3_store);
static DEVICE_ATTR(blink_red4, 0664, NULL, blink_red4_store);
static DEVICE_ATTR(blink_red5, 0664, NULL, blink_red5_store);
static DEVICE_ATTR(blink_green1, 0664, NULL, blink_green1_store);
static DEVICE_ATTR(blink_green2, 0664, NULL, blink_green2_store);
static DEVICE_ATTR(blink_green3, 0664, NULL, blink_green3_store);
static DEVICE_ATTR(blink_green4, 0664, NULL, blink_green4_store);
static DEVICE_ATTR(blink_green5, 0664, NULL, blink_green5_store);
static DEVICE_ATTR(blink_blue1, 0664, NULL, blink_blue1_store);
static DEVICE_ATTR(blink_blue2, 0664, NULL, blink_blue2_store);
static DEVICE_ATTR(blink_blue3, 0664, NULL, blink_blue3_store);
static DEVICE_ATTR(blink_blue4, 0664, NULL, blink_blue4_store);
static DEVICE_ATTR(blink_blue5, 0664, NULL, blink_blue5_store);

static struct attribute *blink_red1_attrs[] = {
	&dev_attr_blink_red1.attr,
	NULL
};
static struct attribute *blink_red2_attrs[] = {
	&dev_attr_blink_red2.attr,
	NULL
};
static struct attribute *blink_red3_attrs[] = {
	&dev_attr_blink_red3.attr,
	NULL
};
static struct attribute *blink_red4_attrs[] = {
	&dev_attr_blink_red4.attr,
	NULL
};
static struct attribute *blink_red5_attrs[] = {
	&dev_attr_blink_red5.attr,
	NULL
};
static struct attribute *blink_green1_attrs[] = {
	&dev_attr_blink_green1.attr,
	NULL
};
static struct attribute *blink_green2_attrs[] = {
	&dev_attr_blink_green2.attr,
	NULL
};
static struct attribute *blink_green3_attrs[] = {
	&dev_attr_blink_green3.attr,
	NULL
};
static struct attribute *blink_green4_attrs[] = {
	&dev_attr_blink_green4.attr,
	NULL
};
static struct attribute *blink_green5_attrs[] = {
	&dev_attr_blink_green5.attr,
	NULL
};
static struct attribute *blink_blue1_attrs[] = {
	&dev_attr_blink_blue1.attr,
	NULL
};
static struct attribute *blink_blue2_attrs[] = {
	&dev_attr_blink_blue2.attr,
	NULL
};
static struct attribute *blink_blue3_attrs[] = {
	&dev_attr_blink_blue3.attr,
	NULL
};
static struct attribute *blink_blue4_attrs[] = {
	&dev_attr_blink_blue4.attr,
	NULL
};
static struct attribute *blink_blue5_attrs[] = {
	&dev_attr_blink_blue5.attr,
	NULL
};

static const struct attribute_group blink_red1_attr_group = {
	.attrs = blink_red1_attrs,
};
static const struct attribute_group blink_red2_attr_group = {
	.attrs = blink_red2_attrs,
};
static const struct attribute_group blink_red3_attr_group = {
	.attrs = blink_red3_attrs,
};
static const struct attribute_group blink_red4_attr_group = {
	.attrs = blink_red4_attrs,
};
static const struct attribute_group blink_red5_attr_group = {
	.attrs = blink_red5_attrs,
};
static const struct attribute_group blink_green1_attr_group = {
	.attrs = blink_green1_attrs,
};
static const struct attribute_group blink_green2_attr_group = {
	.attrs = blink_green2_attrs,
};
static const struct attribute_group blink_green3_attr_group = {
	.attrs = blink_green3_attrs,
};
static const struct attribute_group blink_green4_attr_group = {
	.attrs = blink_green4_attrs,
};
static const struct attribute_group blink_green5_attr_group = {
	.attrs = blink_green5_attrs,
};
static const struct attribute_group blink_blue1_attr_group = {
	.attrs = blink_blue1_attrs,
};
static const struct attribute_group blink_blue2_attr_group = {
	.attrs = blink_blue2_attrs,
};
static const struct attribute_group blink_blue3_attr_group = {
	.attrs = blink_blue3_attrs,
};
static const struct attribute_group blink_blue4_attr_group = {
	.attrs = blink_blue4_attrs,
};
static const struct attribute_group blink_blue5_attr_group = {
	.attrs = blink_blue5_attrs,
};
// Add end


// Add begin by ODM.jianghangxing for: aw9120 driver
static int aw9120_register_class(struct aw9120_chip *chip)
{
	int ret;
	chip->cdev_red1.name = "red1";
	chip->cdev_red1.brightness = LED_OFF;
	chip->cdev_red1.brightness_set = aw9120_red1_brights;

	chip->cdev_red2.name = "red2";
	chip->cdev_red2.brightness = LED_OFF;
	chip->cdev_red2.brightness_set = aw9120_red2_brights;

	chip->cdev_red3.name = "red3";
	chip->cdev_red3.brightness = LED_OFF;
	chip->cdev_red3.brightness_set = aw9120_red3_brights;

	chip->cdev_red4.name = "red4";
	chip->cdev_red4.brightness = LED_OFF;
	chip->cdev_red4.brightness_set = aw9120_red4_brights;

	chip->cdev_red5.name = "red5";
	chip->cdev_red5.brightness = LED_OFF;
	chip->cdev_red5.brightness_set = aw9120_red5_brights;

	chip->cdev_green1.name = "green1";
	chip->cdev_green1.brightness = LED_OFF;
	chip->cdev_green1.brightness_set = aw9120_green1_brights;

	chip->cdev_green2.name = "green2";
	chip->cdev_green2.brightness = LED_OFF;
	chip->cdev_green2.brightness_set = aw9120_green2_brights;

	chip->cdev_green3.name = "green3";
	chip->cdev_green3.brightness = LED_OFF;
	chip->cdev_green3.brightness_set = aw9120_green3_brights;

	chip->cdev_green4.name = "green4";
	chip->cdev_green4.brightness = LED_OFF;
	chip->cdev_green4.brightness_set = aw9120_green4_brights;

	chip->cdev_green5.name = "green5";
	chip->cdev_green5.brightness = LED_OFF;
	chip->cdev_green5.brightness_set = aw9120_green5_brights;

	chip->cdev_blue1.name = "blue1";
	chip->cdev_blue1.brightness = LED_OFF;
	chip->cdev_blue1.brightness_set = aw9120_blue1_brights;

	chip->cdev_blue2.name = "blue2";
	chip->cdev_blue2.brightness = LED_OFF;
	chip->cdev_blue2.brightness_set = aw9120_blue2_brights;

	chip->cdev_blue3.name = "blue3";
	chip->cdev_blue3.brightness = LED_OFF;
	chip->cdev_blue3.brightness_set = aw9120_blue3_brights;

	chip->cdev_blue4.name = "blue4";
	chip->cdev_blue4.brightness = LED_OFF;
	chip->cdev_blue4.brightness_set = aw9120_blue4_brights;

	chip->cdev_blue5.name = "blue5";
	chip->cdev_blue5.brightness = LED_OFF;
	chip->cdev_blue5.brightness_set = aw9120_blue5_brights;

	ret = led_classdev_register(&chip->client->dev, &chip->cdev_red1);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_red2);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_red3);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_red4);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_red5);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_green1);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_green2);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_green3);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_green4);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_green5);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_blue1);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_blue2);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_blue3);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_blue4);
	ret = led_classdev_register(&chip->client->dev, &chip->cdev_blue5);

	ret = sysfs_create_group(&chip->cdev_red1.dev->kobj, &blink_red1_attr_group);
	ret = sysfs_create_group(&chip->cdev_red2.dev->kobj, &blink_red2_attr_group);
	ret = sysfs_create_group(&chip->cdev_red3.dev->kobj, &blink_red3_attr_group);
	ret = sysfs_create_group(&chip->cdev_red4.dev->kobj, &blink_red4_attr_group);
	ret = sysfs_create_group(&chip->cdev_red5.dev->kobj, &blink_red5_attr_group);
	ret = sysfs_create_group(&chip->cdev_green1.dev->kobj, &blink_green1_attr_group);
	ret = sysfs_create_group(&chip->cdev_green2.dev->kobj, &blink_green2_attr_group);
	ret = sysfs_create_group(&chip->cdev_green3.dev->kobj, &blink_green3_attr_group);
	ret = sysfs_create_group(&chip->cdev_green4.dev->kobj, &blink_green4_attr_group);
	ret = sysfs_create_group(&chip->cdev_green5.dev->kobj, &blink_green5_attr_group);
	ret = sysfs_create_group(&chip->cdev_blue1.dev->kobj, &blink_blue1_attr_group);
	ret = sysfs_create_group(&chip->cdev_blue2.dev->kobj, &blink_blue2_attr_group);
	ret = sysfs_create_group(&chip->cdev_blue3.dev->kobj, &blink_blue3_attr_group);
	ret = sysfs_create_group(&chip->cdev_blue4.dev->kobj, &blink_blue4_attr_group);
	ret = sysfs_create_group(&chip->cdev_blue5.dev->kobj, &blink_blue5_attr_group);

	return 0;
}
// Add end


static int aw9120_parse_dt(struct device *dev)
{
	struct device_node *np = dev->of_node;

	chip->pdn_gpio = of_get_named_gpio_flags(np, "qcom,aw9120-pdn", 0, 0);

	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////
// i2c driver
//////////////////////////////////////////////////////////////////////////////////////////
static int aw9120_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
	int err = 0;
	int count =0;
	unsigned int reg_value;

	printk("%s Enter\n", __func__);

	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		err = -ENODEV;
		goto exit_check_functionality_failed;
	}

	chip = kzalloc(sizeof(struct aw9120_chip), GFP_KERNEL);
	if (!chip) {
		dev_err(&client->dev, "Not enough memory\n");
		return -ENOMEM;
	}

	chip->client = client;

	i2c_set_clientdata(client, chip);

	printk("%s: i2c addr=%x", __func__, client->addr);

// Delete begin by ODM.jianghangxing for: aw9120 led driver
	/*
	    err = aw9120_gpio_init();
	    if (err != 0) {
	        return 0;
	    }

	    aw9120_hw_on();
	*/
// Delete end

	err = aw9120_parse_dt(&client->dev);

	if (gpio_is_valid(chip->pdn_gpio)) {
		err = gpio_request(chip->pdn_gpio, "aw9120_pdn");
		if (err) {
			dev_err(&client->dev, "unable to request pdn gpio %d\n", chip->pdn_gpio);
		}

		err = gpio_direction_output(chip->pdn_gpio, 0);
		if (err) {
			dev_err(&client->dev, "unable to set direction for gpio %d\n",
			        chip->pdn_gpio);
		}

		mdelay(5);
		err = gpio_direction_output(chip->pdn_gpio, 1);
		if (err) {
			dev_err(&client->dev, "unable to set direction for gpio %d\n", chip->pdn_gpio);
		}
		// Add begin by ODM.jianghangxing for: aw9120 led driver
		mdelay(5);
		// Add end
	}

	for(count = 0; count < 5; count++) {
		reg_value = i2c_read_reg(chip->client,0x00);                //read chip ID
		printk("aw9120 chip ID = 0x%4x\n",reg_value);
		if (reg_value == 0xb223)
			break;
		msleep(5);
		if(count == 4) {
			pr_err("msg %s read id error\n", __func__);
			err = -ENODEV;
			goto exit_create_singlethread;
		}
	}
// Delete begin by ODM.jianghangxing for: aw9120 led driver
//  aw9120_led_on(chip->client);
//  aw9120_create_sysfs(client);
// Delete end

// Add begin by ODM.jianghangxing for: aw9120 led driver
	aw9120_register_class(chip);
// Add end
	printk("%s Over\n", __func__);
	return 0;

exit_create_singlethread:
	printk("==singlethread error =\n");
	i2c_set_clientdata(client, NULL);
	//aw9120_i2c_client = NULL;
exit_check_functionality_failed:
	return err;
}

static int aw9120_i2c_remove(struct i2c_client *client)
{
	printk("%s enter\n", __func__);

	i2c_set_clientdata(client, NULL);

	return 0;
}

static const struct i2c_device_id aw9120_i2c_id[] = {
	{ AW9120_LED_NAME, 0 },{ }
};
MODULE_DEVICE_TABLE(i2c, aw9120_ts_id);

#ifdef CONFIG_OF
static const struct of_device_id aw9120_i2c_of_match[] = {
	{.compatible = "awinic,aw9120_i2c"},
	{},
};
#endif
static struct i2c_driver aw9120_i2c_driver = {
	.probe = aw9120_i2c_probe,
	.remove = aw9120_i2c_remove,
	.id_table = aw9120_i2c_id,
	.driver = {
		.name = AW9120_LED_NAME,
		.owner = THIS_MODULE,
#ifdef CONFIG_OF
		.of_match_table = aw9120_i2c_of_match,
#endif
	},
};

static int __init aw9120_led_init(void)
{
	int ret;
	printk("%s Enter\n", __func__);

	ret = i2c_add_driver(&aw9120_i2c_driver);
	if (ret) {
		printk("****[%s] Unable to register driver (%d)\n", __func__, ret);
		return ret;
	}
	return ret;
}

static void __exit aw9120_led_exit(void)
{
	i2c_del_driver(&aw9120_i2c_driver);
}

// Modify begin by ODM.jianghangxing for: aw9120 led driver
//module_init(aw9120_led_init);
late_initcall(aw9120_led_init);
// Modify end
module_exit(aw9120_led_exit);

MODULE_AUTHOR("<jhx>");
MODULE_DESCRIPTION("AWINIC AW9120 LED Driver");
MODULE_LICENSE("GPL v2");
