# Compiler and common flags
CC      := clang
CFLAGS  := -g -Wall

# Framework groups
FOUNDATION_FW := -framework Foundation
CG_IMAGE_FW   := -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers
APPKIT_FW     := -framework AppKit

# Targets
ALL_TARGETS := ascii2bin bin2ascii pic2png png2pic

.PHONY: all clean

all: $(ALL_TARGETS)

ascii2bin: ascii2bin.m
	$(CC) $(CFLAGS) $(FOUNDATION_FW) -o $@ $<

bin2ascii: bin2ascii.m
	$(CC) $(CFLAGS) $(FOUNDATION_FW) -o $@ $<

pic2png: pic2png.m
	$(CC) $(CFLAGS) $(FOUNDATION_FW) $(CG_IMAGE_FW) -o $@ $<

png2pic: png2pic.m
	$(CC) $(CFLAGS) $(FOUNDATION_FW) $(APPKIT_FW) $(CG_IMAGE_FW) -o $@ $<

clean:
	rm -f $(ALL_TARGETS)
	rm -rf $(ALL_TARGETS:%=%.dSYM)
