#-----------------------------------------------------------------------------
# Copyright (c) 2009 QUALCOMM Incorporated.
# All Rights Reserved. QUALCOMM Proprietary and Confidential.
#-----------------------------------------------------------------------------

#ifeq ($(TARGET_ARCH),arm)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := i2c-read
LOCAL_SRC_FILES += i2c-read.c
LOCAL_MODULE_PATH := $(TARGET_OUT_DATA)/kernel-tests
include $(BUILD_EXECUTABLE)

#endif
