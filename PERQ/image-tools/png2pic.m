#import <Foundation/Foundation.h>

#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// clang -g -Wall -framework Foundation -framework AppKit -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o png2pic png2pic.m

// take a PNG and and convert it to PERQ "PIC" format

// PIC format:
//    perq images are single-bit monochrome
//    - width (2 bytes, little endian), width in bits
//    - height (2 bytes, little endian), height in scanlines
//    - scan line length (2 bytes, little endian) number of words in a scan line, times 4
//    - block count - (2 bytes, little endian) number of blocks in the file
//    - then block after block of binary data for the raster, word-oriented.
//      LSB first within 16-bit word.  1 = black, 0 = white pixel
//
// Not really an official format (as far as I've been able to tell) but is supported
// by the "SIGUTILS.PAS" found in `sys:Users>demo>` , and my own adaption of 
// GetFastPicture (renamed LoadPicture)




uint8_t *loadPNGAsGreyscale(const char *path,
                            size_t *outWidthBits,
                            size_t *outHeight,
                            size_t *outBytesPerRow)
{
    NSURL *url = [NSURL fileURLWithPath:@(path)];

    CGImageSourceRef src = CGImageSourceCreateWithURL(
        (__bridge CFURLRef)url, NULL);
    CGImageRef image = CGImageSourceCreateImageAtIndex(src, 0, NULL);


    size_t width  = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);

    size_t bytesPerRow = ((width + 63) & ~63) / 8;

    uint8_t *buffer = calloc(width * height, 1);

    CGContextRef ctx = CGBitmapContextCreate(
        buffer,
        width,
        height,
        8,  // bits per component
        width,
        CGColorSpaceCreateDeviceGray(),
        kCGImageAlphaNone
    );

    CGContextDrawImage(ctx,
                       CGRectMake(0, 0, width, height),
                       image);

    CGContextRelease(ctx);

    {
        NSImage *nsimage = [[NSImage alloc] initWithCGImage: image
            size: CGSizeMake(width, height)];

        NSData *imageData = [nsimage TIFFRepresentation];
        [imageData writeToFile: @"blah.tiff"  atomically: YES];
    }


    CGImageRelease(image);
    CFRelease(src);

    *outWidthBits  = width;
    *outHeight     = height;
    *outBytesPerRow = bytesPerRow;

    return buffer;
} // loadPNGAsGreyscale


uint16_t *convertGreyscaleToPERQMonochrome(const uint8_t *src,
                              size_t width,
                              size_t height,
                              size_t srcBytesPerRow)
{
    size_t wordsPerRow = ((width + 63) & ~63) / 16;
    size_t bytesPerRow = wordsPerRow * 2;

    uint16_t *dst = calloc(bytesPerRow * height, 1);

    for (size_t y = 0; y < height; y++) {
        const uint8_t *srcRow = src + y * width;
        uint16_t *dstRow = dst + y * wordsPerRow;

        for (size_t x = 0; x < width; x++) {
            uint8_t g = srcRow[x];

            // not sure if this is a problem if someone sneaks in a color PNG
            if (g == 0x00) {
                dstRow[x / 16] |= (1 << (15 - (x & 15)));
            }
        }
    }

    return dst;
} // convertGreyscaleToPERQMonochrome


static void writeShort(FILE *f, uint16_t v) {
    uint8_t b[2] = { v & 0xFF, v >> 8 };
    fwrite(b, 1, 2, f);
} // writeShort


void writePERQBitmap(const char *path,
                     const uint16_t *bitmapWords,
                     size_t width,
                     size_t height)
{
    size_t wordsPerRow = ((width + 63) & ~63) / 16;
    size_t totalWords = wordsPerRow * height;
    size_t blocks = (totalWords + 255) / 256;

    FILE *f = fopen(path, "wb");
    if (f == NULL) {
        fprintf(stderr, "could not open pic file %s\n", path);
    }

    // ---- Header ----
    writeShort(f, (uint16_t)width);
    writeShort(f, (uint16_t)height);
    writeShort(f, (uint16_t)wordsPerRow);
    writeShort(f, (uint16_t)blocks + 1);

    // ---- Pad header to next block boundary ----
    for (size_t i = 4; i < 256; i++) {
        writeShort(f, 0);
    }

    // ---- Image data ----
    for (size_t i = 0; i < totalWords; i++) {
        writeShort(f, bitmapWords[i]);
    }

    // ---- Pad image data to full blocks ----
    for (size_t i = totalWords; i < blocks * 256; i++) {
        writeShort(f, 0);
    }

    fclose(f);

} // writePERQbitmap


int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "%s input-png output-perq-pic-binary\n", argv[0]);
        fprintf(stderr, "   convert PNG to PERQ PIC binary image\n");
        return EXIT_FAILURE;
    }
    size_t width, height, bytesPerRow;

    uint8_t *pngBits =
        loadPNGAsGreyscale(argv[1],
                           &width,
                           &height,
                           &bytesPerRow);

    uint16_t *perqBits =
        convertGreyscaleToPERQMonochrome(pngBits, width, height, width * 4);

    writePERQBitmap(argv[2], perqBits, width, height);
    
    free(pngBits);
    free(perqBits);

    return EXIT_SUCCESS;

} // main
