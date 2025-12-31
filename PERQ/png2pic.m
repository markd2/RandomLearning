#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// clang -g -Wall -framework Foundation -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o png2pic png2pic.m

// take a perq "PIC" format and convert it to PNG so it can read by mac image
// editing tools.

// PIC format:
//    perq images are single-bit monochrome
//    - width (2 bytes, little endian), width in bits
//    - height (2 bytes, little endian), height in scanlines
//    - scan line length (2 bytes, little endian) number of words in a scan line, times 4
//    - block count - (2 bytes, little endian) number of blocks in the file



// courtesy of our robot overlords

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

    uint8_t *buffer = calloc(bytesPerRow * height, 1);

    CGContextRef ctx = CGBitmapContextCreate(
        buffer,
        width,
        height,
        1,
        bytesPerRow,
        CGColorSpaceCreateDeviceGray(),
        kCGImageAlphaNone
    );

    CGContextDrawImage(ctx,
                       CGRectMake(0, 0, width, height),
                       image);

    CGContextRelease(ctx);
    CGImageRelease(image);
    CFRelease(src);

    *outWidthBits  = width;
    *outHeight     = height;
    *outBytesPerRow = bytesPerRow;

    return buffer;
}


uint16_t *ConvertToPERQBitmap(const uint8_t *src,
                              size_t widthBits,
                              size_t height)
{
    size_t wordsPerRow = ((widthBits + 63) & ~63) / 16;
    size_t bytesPerRow = wordsPerRow * 2;

    uint16_t *dst = malloc(bytesPerRow * height);

    for (size_t y = 0; y < height; y++) {
        const uint8_t *row = src + y * bytesPerRow;

        for (size_t w = 0; w < wordsPerRow; w++) {
            uint16_t word =
                (row[w * 2] << 8) | row[w * 2 + 1];

            // Inverse of PERQ→PNG:
            // MSB-first, 1=white  →  LSB-first, 1=black
//            uint16_t perq =
//                ReverseBits16(word ^ 0xFFFF);
            uint16_t perq = word;

            dst[y * wordsPerRow + w] = perq;
        }
    }

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
    
    uint16_t *perqBits =
        ConvertToPERQBitmap(pngBits, width, height);
    
    WritePERQBitmapFile("/tmp/output.perq",
                        perqBits, width, height);
    
    free(pngBits);
    free(perqBits);

    return EXIT_SUCCESS;

} // main
