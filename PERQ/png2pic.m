#import <Foundation/Foundation.h>

#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// clang -g -Wall -framework Foundation -framework AppKit -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o png2pic png2pic.m

// take a perq "PIC" format and convert it to PNG so it can read by mac image
// editing tools.

// PIC format:
//    perq images are single-bit monochrome
//    - width (2 bytes, little endian), width in bits
//    - height (2 bytes, little endian), height in scanlines
//    - scan line length (2 bytes, little endian) number of words in a scan line, times 4
//    - block count - (2 bytes, little endian) number of blocks in the file



// start courtesy of our robot overlords, actually making it work done by Bork

// no need to swap big-endian value on apple silicon
static void WriteBE16(FILE *f, uint16_t v)
{
//    uint8_t b[2] = { v >> 8, v & 0xFF };
    uint8_t b[2] = { v & 0xFF, v >> 8 };
    fwrite(b, 1, 2, f);
}


uint8_t *LoadPNGAs1Bit(const char *path,
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

//    uint8_t *buffer = calloc(bytesPerRow * height, 1);
    uint8_t *buffer = calloc(width * height, 1);
    memset(buffer, 0xA5, bytesPerRow * height);

    CGContextRef ctx = CGBitmapContextCreate(
        buffer,
        width,
        height,
        8,  // bits per component
//        bytesPerRow,
        width,
        CGColorSpaceCreateDeviceGray(),
        kCGImageAlphaNone
    );

    printf("context %p\n", ctx);

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
}


uint16_t *ConvertToPERQBitmap(const uint8_t *src,
                              size_t widthBits,
                              size_t height,
                              size_t srcBytesPerRow)
{
/*
    for (int i = 0; i < 64; i++) {
        printf("%02d: %hhx\n", i, src[i]);
    }
*/
    size_t width = widthBits;

    size_t wordsPerRow = ((widthBits + 63) & ~63) / 16;
    size_t bytesPerRow = wordsPerRow * 2;

    uint16_t *dst = calloc(bytesPerRow * height, 1);

    for (size_t y = 0; y < height; y++) {
        const uint8_t *srcRow = src + y * width;
        uint16_t *dstRow = dst + y * wordsPerRow;

        for (size_t x = 0; x < widthBits; x++) {
            uint8_t g = srcRow[x];
#if 0
            uint8_t r = srcRow[x + 0];
            uint8_t g = srcRow[px + 1];
            uint8_t b = srcRow[px + 2];

            uint8_t luminance = (r * 30 + g * 59 + b * 11) / 100;
            if (luminance < 128) {
                dstRow[x / 16] |= (1 << (15 - (x & 15)));
            }
#endif
            if (g == 0x00) {
                dstRow[x / 16] |= (1 << (15 - (x & 15)));
            }
        }
    }


#if 0
    for (size_t y = 0; y < height; y++) {
        const uint8_t *row = src + y * bytesPerRow;

        for (size_t w = 0; w < wordsPerRow; w++) {
if (row[w*2] || row[w*2 + 1]) {
    printf("huh? %x %x\n", row[w*2], row[w*2+1]);
}
            uint16_t word =
                (row[w * 2] << 8) | row[w * 2 + 1];

            // Inverse of PERQ→PNG:
            // MSB-first, 1=white  →  LSB-first, 1=black
            // actually do not need to reverse the bits either
//            uint16_t perq =
//                ReverseBits16(word ^ 0xFFFF);
            uint16_t perq = word;


            dst[y * wordsPerRow + w] = perq;
        }
    }
#endif

    return dst;
}


void WritePERQBitmapFile(const char *path,
                          const uint16_t *bitmapWords,
                          size_t widthBits,
                          size_t height)
{
    size_t wordsPerRow = ((widthBits + 63) & ~63) / 16;
    size_t totalWords  = wordsPerRow * height;
    size_t blocks      = (totalWords + 255) / 256;

    FILE *f = fopen(path, "wb");

    // ---- Header ----
    WriteBE16(f, (uint16_t)widthBits);
    WriteBE16(f, (uint16_t)height);
    WriteBE16(f, (uint16_t)wordsPerRow);
    WriteBE16(f, (uint16_t)blocks + 1);

    // ---- Pad header to next block boundary ----
    for (size_t i = 4; i < 256; i++) {
        WriteBE16(f, 0);
    }

    // ---- Image data ----
    for (size_t i = 0; i < totalWords; i++) {
        WriteBE16(f, bitmapWords[i]);
    }

    // ---- Pad image data to full blocks ----
    for (size_t i = totalWords; i < blocks * 256; i++) {
        WriteBE16(f, 0);
    }

    fclose(f);
}



int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s filename - converts PERQ PNG to PIC\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    size_t width, height, bytesPerRow;

    uint8_t *pngBits =
        LoadPNGAs1Bit(argv[1],
                      &width,
                      &height,
                      &bytesPerRow);

    printf("width and height %zu %zu\n", width, height);

    uint16_t *perqBits =
        ConvertToPERQBitmap(pngBits, width, height, width * 4);

    for (int i = 0; i < 10; i++) {
        printf("%02d: %x\n", i, perqBits[i]);
    }
    
    WritePERQBitmapFile("/tmp/output.perq",
                        perqBits, width, height);
    
    free(pngBits);
    free(perqBits);

    return EXIT_SUCCESS;

} // main
