#include <linux/i2c.h>
#include <linux/input.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/regmap.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/gpio/consumer.h>
#include <linux/regulator/consumer.h>
#include <linux/interrupt.h>
#include <linux/gpio.h>
#include <linux/hrtimer.h>
#include <linux/of_gpio.h>
#include <linux/of_irq.h>
#include <linux/time.h>
#include <linux/timer.h>
#include <linux/timex.h>
#include <linux/rtc.h>

struct als_data {
	struct i2c_client *client;
	u32 id;
	int gpio_irq;
	unsigned int irq;
	struct regulator *reg_vdd;
	int regulator_vdd_vmin;
	int regulator_vdd_vmax;
	int regulator_vdd_current;
	struct hrtimer als_timer;
	struct pinctrl *gpio_pinctrl;
	struct pinctrl_state *pinctrl_state_active;
	struct pinctrl_state *pinctrl_state_suspend;
};

struct reg_config {
	u8 reg;
	u8 value;
};

static const struct reg_config als_reg_config[] = {
	{0x01, 0x00},
	{0x02, 0x00},
	{0x05, 0x00},
	{0x06, 0x00},
	{0x07, 0x04},
	{0x01, 0x05},
};

//struct timeval start;
//struct timeval end;
static int intCount = 0;

static u8 als_read_reg(struct i2c_client *client, u8 address)
{
	/*
	struct i2c_msg msg[2];
	u8 buf[4];
	buf[0] = address;

	msg[0].addr  = client->addr;
	msg[0].flags = 0;
	msg[0].len   = 1;
	msg[0].buf   = buf;
	i2c_transfer(client->adapter , msg, 1);
	msg[0].addr  = client->addr;
	msg[0].flags = I2C_M_RD;
	msg[0].len   = 1;
	msg[0].buf   = buf;

	i2c_transfer(client->adapter , msg, 1);
	return (u8)buf[0];
	*/
	return (u8)i2c_smbus_read_word_data(client, address);
}

static int als_write_reg(struct i2c_client *client, u8 address, u8 data)
{
	/*
	u8 buf[4];
	int ret;
	struct i2c_msg msg = {
		.addr = client->addr,
		.flags = 0,
		.len = 2,
		.buf = buf,
	};

	buf[0] = address;
	buf[1] = data;
	ret = i2c_transfer(client->adapter , &msg, 1);
	return ret;
	*/
	return (int)i2c_smbus_write_word_data(client, address, data);
}

static void als_init(struct als_data * als) {
	struct i2c_client *client = als->client;
	int reg_count = ARRAY_SIZE(als_reg_config);
	int i;
	int error;
	pr_err("The als id is : 0x%x", als_read_reg(client, 0x00));
	for(i = 0; i <reg_count; i++) {
		error = als_write_reg(client, als_reg_config[i].reg, als_reg_config[i].value);
		if(error != 0) {
			pr_err("%s:%d, init faild.\n", client->name, als->id);
			break;
		}
	}
	pr_err("The als id is : 0x%x", als_read_reg(client, 0x00));

	if (i == reg_count)
		pr_err("%s:%d, init success.\n", client->name, als->id);
}
static enum hrtimer_restart als_hap_timer(struct hrtimer *timer)
{
	struct als_data *als = container_of(timer, struct als_data,
							 als_timer);
	pr_err("als:enable irq!");
	enable_irq(als->irq);
	return HRTIMER_NORESTART;
}

static irqreturn_t als_interrupt(int irq, void *data)
{
	struct timeval  tm;
	struct als_data *als = data;
	disable_irq_nosync(als->irq);
	hrtimer_start(&als->als_timer,
			ktime_set(5 / 1000, (5 % 1000) * 1000000),
			HRTIMER_MODE_REL);
	intCount++;	
	do_gettimeofday(&tm);
	pr_err("System.out: TEST-DISPALY-KERNEL:%lu%lu     --Count:%d\n", tm.tv_sec, tm.tv_usec/1000, intCount);
	return IRQ_HANDLED;
}


static ssize_t als_start_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	/*
	return sprintf(buf, "Start time :  %lu.%lu\nEnd   time :  %lu.%lu\n",
			(unsigned long)start.tv_sec, (unsigned long)start.tv_usec, 
			(unsigned long)end.tv_sec, (unsigned long)end.tv_usec);
			*/
	return sprintf(buf, "success!");
}

static ssize_t als_start_store(struct device *dev,
		struct device_attribute *attr, const char *buf, size_t count)
{
	int value;
	sscanf(buf, "%d", &value);
	if (value) {
		//do_gettimeofday(&start);
		intCount = 0;
	}
	return count;
}
static u8 als_reg;

static DEVICE_ATTR(start, S_IWUSR | S_IRUGO,
		   als_start_show, als_start_store);

static ssize_t als_reg_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct i2c_client * client = to_i2c_client(dev);
	return sprintf(buf, "read  reg 0x%x =  0x%x\n", (int)als_reg, (int)als_read_reg(client, als_reg));
}

static ssize_t als_reg_store(struct device *dev,
		struct device_attribute *attr, const char *buf, size_t count)
{
	int value;
	sscanf(buf, "%d", &value);
	als_reg = value;
	return count;
}

static DEVICE_ATTR(reg, S_IWUSR | S_IRUGO,
		   als_reg_show, als_reg_store);
static struct attribute *als_attributes[] = {
	&dev_attr_start.attr,
	&dev_attr_reg.attr,
	NULL
};
static const struct attribute_group als_attr_group = {
	.attrs = als_attributes,
};

static int als_parse_dt(struct device *dev, struct als_data *als)
{
	struct device_node *np = dev->of_node;
	int ret;
	u32 temp_val;
	int error;
	u32 voltage_supply[2];
	u32 current_supply;

	error = of_property_read_u32(np, "als,id", &als->id);
	if (error) {
		dev_err(dev, "%s: read toshiba,id faild.\n", __func__);
		return error;
	}
	als->gpio_irq = of_get_named_gpio_flags(np, "als,irq-gpio",
				0, &temp_val);

	als->reg_vdd = regulator_get(dev, "vdd");
	if (IS_ERR(als->reg_vdd)) {
		error = PTR_ERR(als->reg_vdd);
		dev_err(dev, "Error %d getting vdd regulator\n", error);
		return error;
	}
	ret = of_property_read_u32_array(np,"als,vdd-voltage", voltage_supply, 2);
	if (ret < 0) {
		dev_err(dev,
				"%s: Failed to get regulator vdd voltage\n",
				__func__);
	}
	als->regulator_vdd_vmin = voltage_supply[0];
	als->regulator_vdd_vmax = voltage_supply[1];
	ret = regulator_set_voltage(als->reg_vdd,
			als->regulator_vdd_vmin,
			als->regulator_vdd_vmax);
	if (ret < 0) {
		dev_err(dev,
				"%s: Failed to set regulator voltage vdd\n",
				__func__);
	}

	ret = of_property_read_u32(np,"als,vdd-current", &current_supply);
	if (ret < 0) {
		dev_err(dev,
				"%s: Failed to get regulator vdd current\n",
				__func__);
	}
	als->regulator_vdd_current = current_supply;

	ret = regulator_set_load(als->reg_vdd,
			als->regulator_vdd_current);
	if (ret < 0) {
		dev_err(dev,
				"%s: Failed to set regulator current vdd\n",
				__func__);
	}

	return 0;
}

static int als_pinctrl_init(struct device *dev, struct als_data *als)
{
	int error;

	als->gpio_pinctrl = devm_pinctrl_get(dev);
	if (IS_ERR_OR_NULL(als->gpio_pinctrl)) {
		dev_dbg(dev,
			"Device does not use pinctrl\n");
		error = PTR_ERR(als->gpio_pinctrl);
		als->gpio_pinctrl = NULL;
		return error;
	}

	als->pinctrl_state_active
		= pinctrl_lookup_state(als->gpio_pinctrl, "als_active");
	if (IS_ERR_OR_NULL(als->pinctrl_state_active)) {
		dev_dbg(dev,
			"Can not get ts default pinstate\n");
		error = PTR_ERR(als->pinctrl_state_active);
		als->gpio_pinctrl = NULL;
		return error;
	}

	als->pinctrl_state_suspend
		= pinctrl_lookup_state(als->gpio_pinctrl, "als_suspend");
	if (IS_ERR_OR_NULL(als->pinctrl_state_suspend)) {
		dev_dbg(dev,
			"Can not get ts sleep pinstate\n");
		error = PTR_ERR(als->pinctrl_state_suspend);
		als->gpio_pinctrl = NULL;
		return error;
	}

	return 0;
}

static int als_pinctrl_select(struct als_data *data, bool on)
{
	struct pinctrl_state *pins_state;
	int error;

	pins_state = on ? data->pinctrl_state_active
		: data->pinctrl_state_suspend;
	if (!IS_ERR_OR_NULL(pins_state)) {
		error = pinctrl_select_state(data->gpio_pinctrl, pins_state);
		if (error) {
			dev_err(&data->client->dev,
				"can not set %s pins\n",
				on ? "als_active" : "als_suspend");
			return error;
		}
	} else {
		dev_err(&data->client->dev,
			"not a valid '%s' pinstate\n",
				on ? "als_active" : "als_suspend");
	}

	return 0;
}

static int als_regulator_ctrl(struct als_data *als, bool on){
	int error = 0;
	if(on) {
		error = regulator_enable(als->reg_vdd);
		if (error) {
			dev_err(&als->client->dev,
				"vdd enable failed, error=%d\n", error);
			return error;
		}
	} else {
		regulator_disable(als->reg_vdd);
	}
	return 0;
}

static int als_gpio_ctrl(struct als_data *als, bool on){
	int error = 0;

	if (on) {
		if (gpio_is_valid(als->gpio_irq)) {
			error = gpio_request(als->gpio_irq,
				"als_gpio_irq");
			if (error) {
				dev_err(&als->client->dev,
					"unable to request %d gpio(%d)\n",
					als->gpio_irq, error);
				return error;
			}
			error = gpio_direction_input(als->gpio_irq);
			if (error) {
				dev_err(&als->client->dev,
					"unable to set dir for %d gpio(%d)\n",
					als->gpio_irq, error);
				goto err_free_irq;
			}
		}
	} else {
		if (gpio_is_valid(als->gpio_irq))
			gpio_free(als->gpio_irq);
	}

	return 0;

err_free_irq:
	if (gpio_is_valid(als->gpio_irq))
		gpio_free(als->gpio_irq);
	return error;
}

static int als_probe(struct i2c_client *client,
			 const struct i2c_device_id *id)
{
	struct als_data *als;
	int error;
	unsigned long irq_flags;

	als = devm_kzalloc(&client->dev, sizeof(*als), GFP_KERNEL);
	if (!als)
		return -ENOMEM;

	error = als_parse_dt(&client->dev, als);
	if (error)
		return error;
	als->client = client;
	i2c_set_clientdata(client, als);

	error = als_pinctrl_init(&client->dev, als);
	if (error)
		dev_err(&client->dev, "No pinctrl support\n");

	error = als_pinctrl_select(als, true);
	if (error)
		dev_err(&client->dev, "No pinctrl support\n");

	error = als_gpio_ctrl(als, true);
	if (error)
		dev_err(&client->dev, "Failed to configure gpios\n");

	als->irq = gpio_to_irq(als->gpio_irq);

	error = als_regulator_ctrl(als, true);
	if (error)
		dev_err(&client->dev, "Failed to regulator enable\n");

	als_init(als);

	irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
	error = request_threaded_irq(als->irq, als_interrupt, NULL, irq_flags, client->name, als);
	if (error)
		dev_err(&client->dev, "Failed to reques irq\n");

	hrtimer_init(&als->als_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
	als->als_timer.function = als_hap_timer;

	error = sysfs_create_group(&client->dev.kobj, &als_attr_group);
	if (error)
		pr_err("create file sys faiid for als : %d\n",als->id);

	pr_info("%s :%d, als probe success.\n", client->name , als->id);

	return 0;
}

static int __maybe_unused als_suspend(struct device *dev)
{
	struct i2c_client * client = to_i2c_client(dev);
	struct als_data *als = i2c_get_clientdata(client);
	disable_irq(als->irq);
	als_regulator_ctrl(als, false);
	als_gpio_ctrl(als, false);
	als_pinctrl_select(als, false);
	
	return 0;
}

static int __maybe_unused als_resume(struct device *dev)
{
	struct i2c_client * client = to_i2c_client(dev);
	struct als_data *als = i2c_get_clientdata(client);
	als_pinctrl_select(als, true);
	als_gpio_ctrl(als, true);
	als_regulator_ctrl(als, true);
	enable_irq(als->irq);
	return 0;
}

static SIMPLE_DEV_PM_OPS(als_pm_ops, als_suspend, als_resume);

static const struct i2c_device_id als_id[] = {
	{ "epticore,em307", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, als_id);

#ifdef CONFIG_OF
static const struct of_device_id als_of_match[] = {
	{ .compatible = "epticore,em307", },
	{ }
};
MODULE_DEVICE_TABLE(of, als_of_match);
#endif
static struct i2c_driver als_driver = {
	.probe		= als_probe,
	.driver		= {
		.name	= "epticore,em307",
		.of_match_table = of_match_ptr(als_of_match),
		.pm	= &als_pm_ops,
	},
	.id_table = als_id,
};
module_i2c_driver(als_driver);

MODULE_DESCRIPTION("nreal als driver");
MODULE_LICENSE("GPL");
MODULE_AUTHOR("zqdong  <zqdong@nreal.ai>");
