# make libarduino.a

# N.B. this Makefile is not suitable for stand-alone use, used only by ../Makefile

.PHONY: default

CXX = g++
AR = ar
RANLIB = ranlib

OBJS = \
	Adafruit_BME280.o \
	Adafruit_LTR329_LTR303.o \
	Adafruit_MCP23X17.o \
	Adafruit_RA8875.o \
	Arduino.o \
	CourierPrimeSans6.o \
	DateStrings.o \
	EEPROM.o \
	ESP.o \
	ESP8266WiFi.o \
	ESP8266httpUpdate.o \
	Serial.o \
        SPI.o \
	Time.o \
	WiFiClient.o \
	WiFiServer.o \
	WiFiUdp.o \
        Wire.o \
	i2cdriver.o \
	passwords.o \
	timeout.o

default: libarduino.a

libarduino.a: $(OBJS)
	rm -f $@
	$(AR) r $@ $(OBJS)
	$(RANLIB) $@

clean:
	touch x.o x.a x.a.1
	rm -f *.o *.a *.a.*
