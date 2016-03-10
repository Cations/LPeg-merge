LIBNAME = lpeg
LUADIR = ../lua/

COPT = -O2
# COPT = -DLPEG_DEBUG -g

LPEG_OPTIMIZE = -DLPEG_OPTIMIZE
LPEG_FFP = -DLPEG_FFP
LPEG_NAME = -DLPEG_NAME=$(LIBNAME)

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
#	-Wdeclaration-after-statement \
#	-Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) $(LPEG_OPTIMIZE) $(LPEG_NAME) $(LPEG_FFP) -std=c99 -I$(LUADIR) -fPIC
CC = gcc

FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o

# For Linux
linux:
	make $(LIBNAME).so "DLLFLAGS = -shared -fPIC"

# For Mac OS
macosx:
	make $(LIBNAME).so "DLLFLAGS = -bundle -undefined dynamic_lookup"

$(LIBNAME).so: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -o $(LIBNAME).so

$(FILES): makefile

test: test.lua re.lua $(LIBNAME).so
	./test.lua

clean:
	rm -f $(FILES) $(LIBNAME).so


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h
