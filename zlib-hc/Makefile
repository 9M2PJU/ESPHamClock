CXX = g++
AR = ar
RANLIB = ranlib

LIBOBJ =  \
	adler32.o \
	crc32.o \
	deflate.o \
	infback.o \
	inffast.o \
	inflate.o \
	inftrees.o \
	trees.o \
	zutil.o

libzlib-hc.a: $(LIBOBJ)
	$(AR) rc libzlib-hc.a $(LIBOBJ)
	$(RANLIB) libzlib-hc.a

zpipe: zpipe.o libzlib-hc.a
	$(CXX) -o zpipe zpipe.o libzlib-hc.a

clean:
	rm -f *.o *.a zpipe

