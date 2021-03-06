TARGET= vnctest.exe main.exe fbmain.exe

TARGET+=sdlmain.exe
TARGET+=catvnc.exe

CFLAGS=-Wall -Werror
CFLAGS+=-g
CFLAGS+=-O0
CC=gcc

ifneq ($(strip $(shell $(CC) -v 2>&1 | grep "mingw")),)
OS_WIN32=true
endif

ifdef OS_WIN32
CFLAGS+=`yacapi-config --compat --cflags`
LDFLAGS+=`yacapi-config --libs`
endif

all: $(TARGET)

main.o: main.c vnc.h vnc_proto.h
vnc.o: vnc.c vnc.h vnc_proto.h

catvnc.exe: LDFLAGS+=-lm

main.exe: main.o vnc.o
	$(CC) -o $@ $^ $(LDFLAGS)

fbmain.exe: fbmain.o vnc.o
	$(CC) -o $@ $^ $(LDFLAGS)

sdlmain.exe: CFLAGS+=`sdl-config --cflags`
sdlmain.exe: LDFLAGS+=`sdl-config --libs`
sdlmain.exe: sdlmain.o vnc.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.exe:	%.c
	$(CC) -o $@ $(CFLAGS) $< $(LDFLAGS)

clean:
	$(RM) $(TARGET) *.o
