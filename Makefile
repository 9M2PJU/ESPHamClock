# Makefile for HamClock on linux or macos
# type "make help" for possible targets

# HamClock can be built for 16 or 32 bit frame buffers. The default is 32 but either size may be
# specified explicitly by setting FB_DEPTH either here or on the command line to 16 or 32.
# FB_DEPTH=16

# HamClock setup can ask for WiFi creds but by default only does so for fb0 systems. Even this may be
# disabled by setting WIFI_NEVER either here or on the command line to 1.
# WIFI_NEVER=1

# always runs these non-file targets
.PHONY: clean clobber help hclibs install mingw-hclibs mingw-objs mingw-web-800x480 mingw-web-1600x960 mingw-web-2400x1440 mingw-web-3200x1920 mingw-all-web mingw-clean

TOP_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# build flags common to all options and architectures
CXXFLAGS = -I$(TOP_DIR)/include -I$(TOP_DIR)/src -I$(TOP_DIR)/ArduinoLib -I$(TOP_DIR)/wsServer/include -I$(TOP_DIR)/zlib-hc -I. -g -O2 -Wall -pthread -std=c++17
# CXXFLAGS += -Wextra -pedantic -Werror -Wno-attributes -Wno-unknown-pragmas

# add explicit framebuffer depth as _FB_DEPTH if defined
ifdef FB_DEPTH
    CXXFLAGS += -D_FB_DEPTH=$(FB_DEPTH)
endif

# add server alias as _T if defined
ifdef T
    CXXFLAGS += -D_T=$(T)
endif
# add backend server as _B if defined
ifdef B
    CXXFLAGS += -D_B=$(B)
endif

# add software download server as _S if defined
ifdef S
    CXXFLAGS += -D_S=$(S)
endif
# handle WiFi configuration
ifeq ($(WIFI_NEVER),1)
    CXXFLAGS += -D_WIFI_NEVER
endif

LDXXFLAGS = -LArduinoLib -LwsServer -Lzlib-hc -g -pthread
LIBS = -lpthread -larduino -lzlib-hc -lws
CXX = g++
PYTHON = python3

# macOS does not have X11 by default; this assumes XQuartz or macports xorg has been installed
ifeq ($(shell uname -s), Darwin)
    CXXFLAGS += -I/opt/X11/include -I/opt/local/include
    LDXXFLAGS += -L/opt/X11/lib -L/opt/local/lib
endif

# check for proper version of gpiod on linux
ifeq ($(shell GF=/usr/include/gpiod.h; if [ -r $$GF ] && grep -q "gpiod_line " $$GF; then echo yes; fi), yes)
    CXXFLAGS += -D_USE_GPIOD
endif

# FreeBSD needs libgpio libexecinfo and local xorg
ifeq ($(shell uname -s), FreeBSD)
    CXXFLAGS += -I/usr/local/include
    LDXXFLAGS += -L/usr/local/lib
    LIBS += -lgpio -lexecinfo -lm
endif

# NetBSD
ifeq ($(shell uname -s), NetBSD)
    CXXFLAGS += -I/usr/pkg/include -I/usr/X11R7/include
    LDXXFLAGS += -L/usr/pkg/lib -R/usr/pkg/lib -L/usr/X11R7/lib -R/usr/X11R7/lib
    LIBS += -lexecinfo -lm
endif

# Linux needs libgpiod
ifeq ($(shell find /usr/lib -name libgpiod.a 2>/dev/null | wc -l), 1)
    LIBS += -lgpiod
endif

# make CXXFLAGS available to sub makes
export CXXFLAGS

SRCS = $(wildcard src/*.cpp)
OBJS = $(patsubst src/%.cpp,src/%.o,$(SRCS))

help:
	@printf "\nThe following targets are available (as appropriate for your system)\n\n"
	@printf "    hamclock-800x480          X11 GUI desktop version, AKA hamclock\n"
	@printf "    hamclock-1600x960         X11 GUI desktop version, larger, AKA hamclock-big\n"
	@printf "    hamclock-2400x1440        X11 GUI desktop version, larger yet\n"
	@printf "    hamclock-3200x1920        X11 GUI desktop version, huge\n"
	@printf "\n";
	@printf "    hamclock-web-800x480      web server only (no local display)\n"
	@printf "    hamclock-web-1600x960     web server only (no local display), larger\n"
	@printf "    hamclock-web-2400x1440    web server only (no local display), larger yet\n"
	@printf "    hamclock-web-3200x1920    web server only (no local display), huge\n"
	@printf "\n";
	@printf "    hamclock-fb0-800x480      RPi stand-alone /dev/fb0, AKA hamclock-fb0-small\n"
	@printf "    hamclock-fb0-1600x960     RPi stand-alone /dev/fb0, larger, AKA hamclock-fb0\n"
	@printf "    hamclock-fb0-2400x1440    RPi stand-alone /dev/fb0, larger yet\n"
	@printf "    hamclock-fb0-3200x1920    RPi stand-alone /dev/fb0, huge\n"
	@printf "\n";
	@printf "    hamclock                  synonym for hamclock-800x480\n"
	@printf "    hamclock-big              synonym for hamclock-1600x960\n"
	@printf "    hamclock-web              synonym for hamclock-web-800x480\n"
	@printf "    hamclock-web-big          synonym for hamclock-web-1600x960\n"
	@printf "    hamclock-fb0-small        synonym for hamclock-fb0-800x480\n"
	@printf "    hamclock-fb0              synonym for hamclock-fb0-1600x960\n"
	@printf "\n";
	@printf "    install                   install target (default: /usr/local/bin, override with DIR=...)\n"
	@printf "    clean                     remove intermediate object files\n"
	@printf "    clobber                   remove all object files and built binaries\n"
	@printf "\n";
	@printf "    mingw-web-800x480         Windows .exe: headless web server (cross-compiled via MinGW-w64)\n"
	@printf "    mingw-web-1600x960        Windows .exe: headless web server, larger\n"
	@printf "    mingw-web-2400x1440       Windows .exe: headless web server, larger yet\n"
	@printf "    mingw-web-3200x1920       Windows .exe: headless web server, huge\n"
	@printf "    mingw-all-web             build all four Windows .exe targets\n"
	@printf "    mingw-clean               remove MinGW cross-compile artifacts\n"
	@printf "\n"
	@printf "    NB: run 'make clean' before mingw targets if switching from native builds\n"
	@printf "\n"

hclibs:
	$(MAKE) -C ArduinoLib libarduino.a
	$(MAKE) -C wsServer
	$(MAKE) -C zlib-hc

src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# basic X11 versions

hamclock: hamclock-800x480
	cp $? $@

hamclock-big: hamclock-1600x960
	cp $? $@

hamclock-800x480: CXXFLAGS+=-D_USE_X11
hamclock-800x480: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -lX11 -o $@ $(LIBS)

hamclock-1600x960: CXXFLAGS+=-D_USE_X11 -D_CLOCK_1600x960
hamclock-1600x960: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -lX11 -o $@ $(LIBS)

hamclock-2400x1440: CXXFLAGS+=-D_USE_X11 -D_CLOCK_2400x1440
hamclock-2400x1440: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -lX11 -o $@ $(LIBS)

hamclock-3200x1920: CXXFLAGS+=-D_USE_X11 -D_CLOCK_3200x1920
hamclock-3200x1920: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -lX11 -o $@ $(LIBS)

# web server versions

hamclock-web: hamclock-web-800x480
	cp $? $@

hamclock-web-big: hamclock-web-1600x960
	cp $? $@

hamclock-web-800x480: CXXFLAGS+=-D_WEB_ONLY
hamclock-web-800x480: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-web-1600x960: CXXFLAGS+=-D_WEB_ONLY -D_CLOCK_1600x960
hamclock-web-1600x960: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-web-2400x1440: CXXFLAGS+=-D_WEB_ONLY -D_CLOCK_2400x1440
hamclock-web-2400x1440: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-web-3200x1920: CXXFLAGS+=-D_WEB_ONLY -D_CLOCK_3200x1920
hamclock-web-3200x1920: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

# RPi fb0 versions

hamclock-fb0-small: hamclock-fb0-800x480
	cp $? $@

hamclock-fb0: hamclock-fb0-1600x960
	cp $? $@

hamclock-fb0-800x480: CXXFLAGS+=-D_USE_FB0
hamclock-fb0-800x480: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-fb0-1600x960: CXXFLAGS+=-D_USE_FB0 -D_CLOCK_1600x960
hamclock-fb0-1600x960: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-fb0-2400x1440: CXXFLAGS+=-D_USE_FB0 -D_CLOCK_2400x1440
hamclock-fb0-2400x1440: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

hamclock-fb0-3200x1920: CXXFLAGS+=-D_USE_FB0 -D_CLOCK_3200x1920
hamclock-fb0-3200x1920: $(OBJS) hclibs
	$(CXX) $(LDXXFLAGS) $(OBJS) -o $@ $(LIBS)

install:
	@SOURCE=hamclock-*0x*0 ; \
	DIR=$${DIR:-/usr/local/bin} ; \
	TARGET=$$DIR/hamclock ; \
	if ! [ -x $$SOURCE ] ; then \
		echo 'make something first' ; \
		make help ; \
	elif [ `id -un` != 'root' ] && \
	     ( D="$$DIR"; \
	       while [ ! -d "$$D" ]; do \
	           D=`dirname "$$D"`; \
	       done ; \
	       [ -w "$$D" ] ) ; then \
		mkdir -p $$DIR \
		&& mv -f $$SOURCE $$TARGET ; \
	elif [ `id -un` != 'root' ] ; then \
		echo please run with sudo ; \
	else \
		mkdir -p $$DIR \
		&& mv -f $$SOURCE $$TARGET \
		&& chown root $$TARGET \
		&& chmod u+s $$TARGET; \
	fi

clean:
	$(MAKE) -C ArduinoLib clean
	$(MAKE) -C wsServer clean
	$(MAKE) -C zlib-hc clean
	touch src/x.o src/x.dSYM
	rm -rf src/*.o *.o src/*.dSYM *.dSYM

clobber: clean
	touch hamclock hamclock-
	rm -rf hamclock hamclock-*

# === MinGW-w64 cross-compilation for Windows (_WEB_ONLY) ===
#
# Builds native Windows .exe binaries of the headless web-only HamClock.
# Requires: mingw-w64 toolchain (e.g. pacman -S mingw-w64-gcc on Arch,
# or apt install g++-mingw-w64-x86-64 on Debian/Ubuntu).
#
# Usage:
#   make mingw-web-800x480
#   make mingw-web-1600x960
#   make mingw-web-2400x1440
#   make mingw-web-3200x1920
#   make mingw-all-web
#
# The resulting .exe runs the HTTP/WebSocket server; open
# http://localhost:8081/live.html in a browser to view the dashboard.

MINGW_PREFIX = x86_64-w64-mingw32
MINGW_CXX    = $(MINGW_PREFIX)-g++
MINGW_AR     = $(MINGW_PREFIX)-ar
MINGW_RANLIB = $(MINGW_PREFIX)-ranlib

MINGW_CXXFLAGS = -I$(TOP_DIR)/include -I$(TOP_DIR)/src -I$(TOP_DIR)/ArduinoLib -I$(TOP_DIR)/wsServer/include -I$(TOP_DIR)/zlib-hc -I. -g -O2 -Wall -pthread -std=c++17 -D_WEB_ONLY -D_WIN32_WINNT=0x0601 -D_USE_MATH_DEFINES
MINGW_LDXXFLAGS = -LArduinoLib -LwsServer -Lzlib-hc -g -pthread -static
MINGW_LIBS = -larduino -lzlib-hc -lws -lpthread -lws2_32 -lwinpthread

# build sub-libraries with the MinGW toolchain
mingw-hclibs:
	$(MAKE) -C ArduinoLib libarduino.a CXX="$(MINGW_CXX)" AR="$(MINGW_AR)" RANLIB="$(MINGW_RANLIB)" CXXFLAGS="$(MINGW_CXXFLAGS)"
	$(MAKE) -C wsServer CC="$(MINGW_CXX)" AR="$(MINGW_AR)" CXXFLAGS="$(MINGW_CXXFLAGS) -Iinclude"
	$(MAKE) -C zlib-hc CXX="$(MINGW_CXX)" AR="$(MINGW_AR)" RANLIB="$(MINGW_RANLIB)" CXXFLAGS="$(MINGW_CXXFLAGS)"

# build src/*.o with the MinGW toolchain (recursive make to override CXX/CXXFLAGS)
mingw-objs: mingw-hclibs
	$(MAKE) $(OBJS) CXX="$(MINGW_CXX)" CXXFLAGS="$(MINGW_CXXFLAGS)"

mingw-web-800x480: mingw-objs
	$(MINGW_CXX) $(MINGW_LDXXFLAGS) $(OBJS) -o $@.exe $(MINGW_LIBS)

mingw-web-1600x960: MINGW_CXXFLAGS += -D_CLOCK_1600x960
mingw-web-1600x960: mingw-objs
	$(MINGW_CXX) $(MINGW_LDXXFLAGS) $(OBJS) -o $@.exe $(MINGW_LIBS)

mingw-web-2400x1440: MINGW_CXXFLAGS += -D_CLOCK_2400x1440
mingw-web-2400x1440: mingw-objs
	$(MINGW_CXX) $(MINGW_LDXXFLAGS) $(OBJS) -o $@.exe $(MINGW_LIBS)

mingw-web-3200x1920: MINGW_CXXFLAGS += -D_CLOCK_3200x1920
mingw-web-3200x1920: mingw-objs
	$(MINGW_CXX) $(MINGW_LDXXFLAGS) $(OBJS) -o $@.exe $(MINGW_LIBS)

mingw-all-web: mingw-web-800x480 mingw-web-1600x960 mingw-web-2400x1440 mingw-web-3200x1920

mingw-clean:
	$(MAKE) -C ArduinoLib clean
	$(MAKE) -C wsServer clean
	$(MAKE) -C zlib-hc clean
	touch src/x.o
	rm -rf src/*.o mingw-web-*.exe
