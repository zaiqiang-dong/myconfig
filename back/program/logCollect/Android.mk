LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := logcatch
LOCAL_SRC_FILES += logcatch.cpp
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall

LOCAL_C_INCLUDES := external/libcxx/include \
                    $(QC_PROP_ROOT)/fastmmi/libmmi \
                    $(QC_PROP_ROOT)/diag/include \
                    $(QC_PROP_ROOT)/diag/src/ \
                    $(TARGET_OUT_HEADERS)/common/inc \

LOCAL_SHARED_LIBRARIES := libcutils libutils libmmi libdiag libc++

LOCAL_MODULE_PATH := $(TARGET_OUT_DATA)/kernel-tests
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif

include $(BUILD_EXECUTABLE)
