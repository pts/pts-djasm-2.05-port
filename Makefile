# by pts@fazekas.hu at Wed Nov 20 02:30:05 CET 2024

ARCHFLAGS =
ARCHFLAGS_M32 = -m32 -march=i686 -falign-functions=1 -falign-jumps=1 -falign-loops=1 -mpreferred-stack-boundary=2
CFLAGS = -DUSE_CTIME_R
WFLAGS = -ansi -pedantic -W -Wall -Wstrict-prototypes -Werror-implicit-function-declaration
OFLAGS = -Os -fsigned-char -ffunction-sections -fdata-sections
LFLAGS = -Wl,--gc-sections
GCC = gcc
PRIMARY = djasm
PRIMARYTEST = test-djasm
TESTFILES = test/stub.asm test/stub.h.exp test/stub.map.exp

.SUFFIXES:  # Disable builtin rules of GNU Make.
.PHONY: primary clean test test-djasm
primary: $(PRIMARY)
test: $(PRIMARYTEST)
all: djasm djasm.m32 djasm.mini djasm.exe test-djasm test-djasm-m32 test-djasm-mini test-djasm-exe

clean:
	rm -f djasm djasm.m32 djasm.mini djasm.exe

djasm: djasm.c
	$(GCC) $(ARCHFLAGS) $(LFLAGS) $(CFLAGS) $(OFLAGS) $(WFLAGS) -o $@ $<
	ls -l $@

djasm.m32: djasm.c
	$(GCC) $(ARCHFLAGS_M32) $(LFLAGS) $(CFLAGS) $(OFLAGS) $(WFLAGS) -o $@ $<
	ls -l $@

# minicc is from https://github.com/pts/minilibc686
# Adding -fomit-frame-pointer doesn't make a difference for --gcc=4.8, but it makes the default (--wcc) smaller.
# Default (--wcc) generates smaller code than --gcc=4.8.
djasm.mini: djasm.c
#	#minicc --gcc=4.8 -ansi -pedantic -Wadd=strict-prototypes $(CFLAGS) -ffunction-sections -fdata-sections -Wl,--gc-sections -o $@ $<
	minicc -ansi -pedantic $(CFLAGS) -fomit-frame-pointer -Wno-n124 -o $@ $<
	ls -l $@

# OpenWatcom C compiler, Win32 target. https://open-watcom.github.io/
djasm.exe: djasm.c
	owcc -bwin32 -Wl,runtime -Wl,console=3.10 -o djasm.exe -Os -s -fno-stack-check -march=i386 -W -Wall -Wno-n124 -o $@ $<
	rm -f djasm.o
	ls -l $@

test-djasm: djasm $(TESTFILES)
	rm -f test/stub.h test/stub.map
	cd test && TZ=GMT ../$< -dt stub.asm stub.h stub.map
	diff test/stub.h.exp test/stub.h
	diff test/stub.map.exp test/stub.map
	: $@ OK.

test-djasm-m32: djasm.m32 $(TESTFILES)
	rm -f test/stub.h test/stub.map
	cd test && TZ=GMT ../$< -dt stub.asm stub.h stub.map
	diff test/stub.h.exp test/stub.h
	diff test/stub.map.exp test/stub.map
	: $@ OK.

test-djasm-mini: djasm.mini $(TESTFILES)
	rm -f test/stub.h test/stub.map
	cd test && TZ=GMT ../$< -dt stub.asm stub.h stub.map
	diff test/stub.h.exp test/stub.h
	diff test/stub.map.exp test/stub.map
	: $@ OK.

test-djasm-exe: djasm.exe $(TESTFILES)
	rm -f test/stub.h test/stub.map test/djasm.exe
	ln -s ../$< test/$<
	cd test && TZ=GMT dosbox.nox.static --cmd --mem-mb=2 --env TZ=GMT mwperun.exe $< -dt stub.asm stub.h stub.map
	rm -f test/stub.exe
	diff -Z test/stub.h.exp test/stub.h
	diff -Z test/stub.map.exp test/stub.map
	: $@ OK.
