/*
 * win32_compat.h - POSIX compatibility shims for building HamClock (_WEB_ONLY)
 * as a native Windows executable via MinGW-w64 cross-compilation.
 *
 * This header is included when _WIN32 is defined. It provides:
 *   - Winsock2 includes and initialization
 *   - Inline replacements for POSIX functions not available on Windows
 *   - No-op stubs for Unix-only syscalls (getuid, fchown, flock, etc.)
 *
 * The X11 (_USE_X11) and framebuffer (_USE_FB0) backends are NOT supported
 * on Windows; only the headless _WEB_ONLY backend works.
 */

#ifndef _WIN32_COMPAT_H
#define _WIN32_COMPAT_H

#ifdef _WIN32

/* Ensure M_PI and other math constants are available from cmath/math.h.
 * MinGW only defines them when _USE_MATH_DEFINES is set. */
#ifndef _USE_MATH_DEFINES
#define _USE_MATH_DEFINES
#endif

/* Define these before including windows.h to minimize macro conflicts:
 * - WIN32_LEAN_AND_MEAN: exclude rarely-used Windows headers
 * - NOMINMAX: prevent min/max macros that conflict with std::min/max
 * - NOGDI: prevent GDI defines that conflict with HamClock names
 * - _NOGDI_ : extra guard
 */
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif
#ifndef NOGDI
#define NOGDI
#endif

/* Winsock must be included before windows.h to avoid conflicts */
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>

#include <io.h>
#include <process.h>
#include <direct.h>
#include <fcntl.h>
#include <time.h>
#include <ctype.h>

/* Undef Windows macros that conflict with HamClock code.
 * HamClock uses INPUT/OUTPUT for GPIO pin modes, but windows.h defines
 * INPUT (from winuser.h) for SendInput. Windows also defines IN/OUT
 * as empty macros for SAL annotations, which conflict with P13.h
 * satellite class member names. Remove all of these. */
#ifdef INPUT
#undef INPUT
#endif
#ifdef OUTPUT
#undef OUTPUT
#endif
#ifdef IN
#undef IN
#endif
#ifdef OUT
#undef OUT
#endif

/* ---- Missing POSIX constants ---- */

#ifndef EINPROGRESS
#define EINPROGRESS WSAEWOULDBLOCK
#endif

#ifndef ETIMEDOUT
#define ETIMEDOUT WSAETIMEDOUT
#endif

/* EAGAIN maps to WSAEWOULDBLOCK on Windows */
#ifndef EAGAIN
#define EAGAIN WSAEWOULDBLOCK
#endif

/* MSG_NOSIGNAL not defined on Windows */
#ifndef MSG_NOSIGNAL
#define MSG_NOSIGNAL 0
#endif

/* SO_REUSEPORT not defined on Windows; use SO_REUSEADDR */
#ifndef SO_REUSEPORT
#define SO_REUSEPORT SO_REUSEADDR
#endif

/* SHUT_RDWR is defined in winsock2.h but guard just in case */
#ifndef SHUT_RDWR
#define SHUT_RDWR SD_BOTH
#endif

/* ---- Missing POSIX types ---- */
/* pid_t is already defined in MinGW's sys/types.h, no need to redefine */
/* socklen_t is defined in ws2tcpip.h */

/* ---- Inline shims for missing POSIX functions ---- */

/* getuid/getgid/geteuid: Windows has no Unix uid/gid model.
 * Return 0 to simulate root; fchown/chown become no-ops. */
static inline int getuid(void)  { return 0; }
static inline int getgid(void)  { return 0; }
static inline int geteuid(void) { return 0; }

/* fchown/chown: no-op on Windows (no ownership model) */
static inline int fchown(int fd, int uid, int gid) { (void)fd; (void)uid; (void)gid; return 0; }
static inline int chown(const char *path, int uid, int gid) { (void)path; (void)uid; (void)gid; return 0; }

/* flock: no-op on Windows (file locking uses LockFileEx, but for
 * HamClock's single-instance guard this is safe to stub) */
#ifndef LOCK_EX
#define LOCK_EX 2
#define LOCK_NB 4
#define LOCK_SH 1
#define LOCK_UN 8
#endif
static inline int flock(int fd, int operation) { (void)fd; (void)operation; return 0; }

/* fork: not available on Windows. HamClock only forks for reboot/poweroff
 * (not reachable in _WEB_ONLY mode) and for sensor helpers (macOS/Linux only).
 * This stub returns -1 to indicate failure; callers handle it gracefully. */
static inline pid_t fork(void) { return -1; }

/* setenv: MinGW does not provide setenv; use _putenv */
static inline int setenv(const char *name, const char *value, int overwrite)
{
    (void)overwrite;  /* _putenv always overwrites */
    char buf[1024];
    snprintf(buf, sizeof(buf), "%s=%s", name, value);
    return _putenv(buf);
}

/* usleep: MinGW already provides usleep in unistd.h, so no shim needed */

/* getrusage: not available on Windows. Stub with zeros. */
#ifndef RUSAGE_SELF
#define RUSAGE_SELF 0
#endif
struct rusage {
    struct timeval ru_utime;
    struct timeval ru_stime;
    long ru_maxrss;
    long ru_idrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nvcsw;
    long ru_nivcsw;
};
static inline int getrusage(int who, struct rusage *usage)
{
    (void)who;
    memset(usage, 0, sizeof(*usage));
    return 0;
}

/* environ: not directly accessible on Windows */
#define environ _environ

/* system: available via MSVCRT, but guard against shell differences */
/* (system() works on Windows through cmd.exe, so no shim needed) */

/* pipe: use _pipe on Windows */
#ifndef pipe
static inline int pipe(int fds[2])
{
    return _pipe(fds, 0, _O_BINARY);
}
#endif

/* mkdir: Windows mkdir takes 1 arg (path), POSIX takes 2 (path, mode).
 * Wrap to ignore the mode argument. */
#define mkdir(path, mode) _mkdir(path)

/* gmtime_r / localtime_r: POSIX reentrant versions.
 * Windows provides gmtime_s / localtime_s with reversed argument order. */
static inline struct tm *gmtime_r(const time_t *timep, struct tm *result)
{
    return gmtime_s(result, timep) == 0 ? result : NULL;
}
static inline struct tm *localtime_r(const time_t *timep, struct tm *result)
{
    return localtime_s(result, timep) == 0 ? result : NULL;
}

/* timegm: inverse of gmtime (convert struct tm in UTC to time_t).
 * Not available on Windows; implement using _mkgmtime. */
static inline time_t timegm(struct tm *tm)
{
    return _mkgmtime(tm);
}

/* strcasestr: case-insensitive substring search (GNU extension).
 * Not available on Windows; implement a simple version. */
static inline char *strcasestr(const char *haystack, const char *needle)
{
    if (!*needle)
        return (char *)haystack;
    for (const char *h = haystack; *h; h++) {
        const char *hh = h;
        const char *n = needle;
        while (*hh && *n && tolower((unsigned char)*hh) == tolower((unsigned char)*n)) {
            hh++;
            n++;
        }
        if (!*n)
            return (char *)h;
    }
    return NULL;
}

/* strsep: split string at delimiter (BSD/POSIX).
 * Not available on Windows; implement a simple version. */
static inline char *strsep(char **stringp, const char *delim)
{
    char *begin = *stringp;
    if (!begin)
        return NULL;
    char *end = begin + strcspn(begin, delim);
    if (*end) {
        *end++ = '\0';
        *stringp = end;
    } else {
        *stringp = NULL;
    }
    return begin;
}

/* mmap/munmap: HamClock uses mmap only for read-only file mapping of earth map
 * pixels. On Windows, replace with malloc+fread (simpler than CreateFileMapping
 * and adequate for this use case). */
#define PROT_READ    1
#define PROT_WRITE   2
#define MAP_PRIVATE  2
#define MAP_FAILED   ((void *)-1)

static inline void *hc_mmap(void *addr, size_t length, int prot, int flags, int fd, long offset)
{
    (void)addr;
    (void)prot;
    (void)flags;
    void *buf = malloc(length);
    if (!buf)
        return MAP_FAILED;
    long cur = lseek(fd, 0, SEEK_CUR);
    lseek(fd, offset, SEEK_SET);
    ssize_t n = read(fd, buf, length);
    lseek(fd, cur, SEEK_SET);
    if (n != (ssize_t)length) {
        free(buf);
        return MAP_FAILED;
    }
    return buf;
}

static inline int hc_munmap(void *addr, size_t length)
{
    (void)length;
    free(addr);
    return 0;
}

#define mmap(addr, length, prot, flags, fd, offset) hc_mmap((addr), (length), (prot), (flags), (fd), (offset))
#define munmap(addr, length) hc_munmap((addr), (length))

/* WIFEXITED/WEXITSTATUS: not available on Windows. Since fork/execv is stubbed
 * to return -1, these macros just need to compile. */
#ifndef WIFEXITED
#define WIFEXITED(s) 0
#endif
#ifndef WEXITSTATUS
#define WEXITSTATUS(s) 0
#endif
#ifndef WIFSIGNALED
#define WIFSIGNALED(s) 0
#endif
#ifndef WTERMSIG
#define WTERMSIG(s) 0
#endif

/* wait/waitpid: not available on Windows (no sys/wait.h).
 * Since fork() is stubbed to return -1, these will never be called
 * in practice, but must compile. */
static inline int wait(int *status) { (void)status; return -1; }
static inline int waitpid(int pid, int *status, int options) { (void)pid; (void)status; (void)options; return -1; }

/* WSAStartup initialization - call once at program start */
static inline void hc_winsock_init(void)
{
    static int initialized = 0;
    if (!initialized) {
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
            fprintf(stderr, "WSAStartup failed: %d\n", WSAGetLastError());
            exit(1);
        }
        initialized = 1;
    }
}

/* hc_winsock_cleanup - call at exit */
static inline void hc_winsock_cleanup(void)
{
    WSACleanup();
}

#else /* !_WIN32 */

/* On non-Windows, define a no-op init so callers don't need #ifdef */
static inline void hc_winsock_init(void) {}
static inline void hc_winsock_cleanup(void) {}

#endif /* _WIN32 */

#endif /* _WIN32_COMPAT_H */
