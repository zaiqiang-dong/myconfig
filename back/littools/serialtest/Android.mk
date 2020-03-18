LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

#LOCAL_SRC_FILES := serial.c
LOCAL_SRC_FILES := serial.c
#LOCAL_MODULE := serial
LOCAL_MODULE := serial
LOCAL_MODULE_TAGS := optional
$(shell mkdir -p $(TARGET_OUT)/etc/gpsconfig)
$(shell cp -rf $(LOCAL_PATH)/gpsconfig/gps.conf $(TARGET_OUT)/etc/gpsconfig)
$(shell cp -rf $(LOCAL_PATH)/gpsconfig/inputevent.sh $(TARGET_OUT)/etc/gpsconfig)
include $(BUILD_EXECUTABLE)

