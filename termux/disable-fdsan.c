#include <dlfcn.h>

/*
 * Disable Android Bionic libc fdsan abort behavior.
 * Android 10+ aborts processes if file descriptors are closed while owned by FILE*.
 */
enum {
    ANDROID_FDSAN_ERROR_LEVEL_DISABLED = 0,
    ANDROID_FDSAN_ERROR_LEVEL_WARN_ONCE = 1,
    ANDROID_FDSAN_ERROR_LEVEL_WARN_ALWAYS = 2,
    ANDROID_FDSAN_ERROR_LEVEL_FATAL = 3,
};

__attribute__((constructor)) static void disable_android_fdsan(void) {
    typedef void (*set_error_level_t)(int);
    set_error_level_t set_level = (set_error_level_t)dlsym(RTLD_DEFAULT, "android_fdsan_set_error_level");
    if (set_level) {
        set_level(ANDROID_FDSAN_ERROR_LEVEL_DISABLED);
    }
}
