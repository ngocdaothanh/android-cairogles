LOCAL_PATH := $(call my-dir)

include jni/cairo.mk
include $(CLEAR_VARS)

LOCAL_MODULE    := android-cairogles
LOCAL_CFLAGS    := $(LIBPIXMAN_CFLAGS) $(LIBCAIRO_CFLAGS)
LOCAL_LDLIBS    := -lm -llog -landroid -lEGL -lGLESv2 -lz
LOCAL_SRC_FILES := main.cpp
LOCAL_STATIC_LIBRARIES := libpixman libcairogles cpufeatures android_native_app_glue

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/cpufeatures)
$(call import-module,android/native_app_glue)
