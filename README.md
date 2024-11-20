# pts-djasm-2.05-port: a port of the DJASM 2.05 assembler to standard C and C++

pts-djasm-2.05-port is a port of the C source code of the DJASM 2.05
assembler (released on 2015-05-11) by DJ Delorie (and multiple contributors)
to standard C and C++ and multiple C and C++ compilers. The port also
contains a build script for
[minilibc686](https://github.com/pts/minilibc686), producing a small Linux
i386 executable program (<59 KB). Version 2.05 has been the latest release
of DJGPP (and thus DJASM) between 2015 and 2024.

To build it, clone the repo, and (on Linux or other Unix) with GCC
installed, run `make djasm`. To build and test it, run `make test-djsam`.
Other targets are also available, for example `make djasm.mini` builds with
*minicc*, linking against [minilibc686](https://github.com/pts/minilibc686),
producing a small Linux i386 executable program (<59 KB).

The port doesn't have any feature additions or changes, but it contains some
fixes which report a meaningful error message instead of crashing (e.g. if a
symbol name longer than 200 characters is encountered).

The documentation is in the [djasm.info](djasm.info) file (it can be viewed
as a regular text file or with an Info file viewer such as info(1)), copied
from the original release
([djlsr205.zip](https://mirrors.fe.up.pt/pub/djgpp/current/v2/djlsr205.zip)
and
[djdev205.zip](https://mirrors.fe.up.pt/pub/djgpp/current/v2/djdev205.zip)).

The port has been tested with the following C compilers:

* GCC >=4.1 targeting Linux
* Clang >=6.0.0 targeting Linux
* OpenWatcom C compiler (32-bit) 2023-03-04 targeting Linux i386 and Win32
* TinyCC 0.9.26 targeting Linux
* PCC 1.1.0 targeting Linux

The port has been tested with the following C++ compilers:

* GCC g++ >=4.8 targeting Linux
* Clang clang++ >=6.0.0 targeting Linux

The port is conforming to C89 (ANSI C), C99, C++98 and C++11; and possibly
later versions of the C and C++ standards.

Please note that the same source file (djasm.c) in the port works as both a
C and C++ program, prividing the same functionality. The original djasm.c
didn't compile in C++.

## Features of DJASM

* Raw binary output files (including .bin with *org 0* and DOS .com).
* Some other variations of raw binary output files, such as DOS .exe without
  relocation and C .h files containing the DOS exe as an unsigned char
  array.
* Map file generation if the user asks for it.
* A subset of 16-bit and 32-bit Intel x86 instruction set (i.e. 8086, 186, 286,
  *386) in 16-bit mode (i.e. inc ax* is always 1 byte, *inc eax* is always 2
  *bytes).
* No floating-point (FPU, x87) instructions.
* No protected-mode setup instructions.
* No conditional compilation.
* No macros.
* It cannot autodetect whether a jump is short (1-byte) or near (2-byte).
* Single-pass, it cannot optimize effective addresses of forward-references.

The source code ([djasm.y](djasm.y)) is written in Yacc + C, and it is easy
to read and modify. It can be used as an example when teaching Yacc and C,
with some homework assignments of adding new features.

New projects with x86 assembly probably shouldn't use DJASM, but some more
featureful, mainstream assembler such as NASM or GNU as(1) instead.

## How DJASM was born and first used

The historical significance of DJASM is that the go32.exe stub used by DJGPP
([stub.asm](test/stub.asm)) was and is written using DJASM. When DJGPP 1.x
was developed (starting in 1989, continuing in the 1990s), no free-software
assembler was around to be used, so DJ Delorie wrote one with a single
purpose: to build *stub.asm* from source, as part of the DJGPP build
process.

Actually, the earliest free-software assembler for 16-bit x86 that could
have worked was [as86 from
1991-11-29](https://mirror.math.princeton.edu/pub/oldlinux/Linux.old/bin/as86.src.tar.Z).
NASM wasn't around that time, and it became stable in 1997. The GNU
Assembler, GNU as(1) wasn't able to genreate 16-bit x86 code at that time
(only 32-bit).
