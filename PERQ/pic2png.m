#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>


// take a perq "PIC" format and convert it to PNG so it can read by mac image
// editing tools.

// PIC format:
//    perq images are single-bit monochrome
//    - width (2 bytes, little endian), width in bits
//    - height (2 bytes, little endian), height in scanlines
//    - scan line length (2 bytes, little endian) number of words in a scan line, times 4
//    - block count - (2 bytes, little endian) number of blocks in the file

// clang -g -Wall -framework Foundation -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o pic2png pic2png.m


// courtesy of robot overlords

void Write1BitBitmapToPNG(const void *bitmapData,
                          size_t widthBits,
                          size_t height,
                          size_t bytesPerRow,
                          NSString *outputPath)
{
    // Create data provider (no copy)
    CGDataProviderRef provider =
        CGDataProviderCreateWithData(NULL,
                                     bitmapData,
                                     bytesPerRow * height,
                                     NULL);

    // 1-bit grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    // Bitmap info:
    // - 1 bit per component
    // - No alpha
    // - MSB first (most common for bitmaps)
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;

    CGImageRef image = CGImageCreate(
        widthBits,          // width (pixels)
        height,             // height (pixels)
        1,                  // bits per component
        1,                  // bits per pixel
        bytesPerRow,        // bytes per row
        colorSpace,
        bitmapInfo,
        provider,
        NULL,               // decode
        false,              // should interpolate
        kCGRenderingIntentDefault
    );

    if (!image) {
        NSLog(@"Failed to create CGImage");
        return;
    }

    NSURL *url = [NSURL fileURLWithPath:outputPath];

    CGImageDestinationRef destination =
        CGImageDestinationCreateWithURL(
            (__bridge CFURLRef)url,
            (CFStringRef)UTTypePNG.identifier,
            1,
            NULL
        );

    CGImageDestinationAddImage(destination, image, NULL);

    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write PNG");
    }

    // Cleanup
    CFRelease(destination);
    CGImageRelease(image);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
} // Write1BitBitmapToPNG


/*
PERQ monochrome framebuffers use:
Property	PERQ
Pixel depth	1 bit
Word size	16-bit
Scanline alignment	64 bits
Bit order	LSB first within 16-bit word
Pixel polarity	1 = black, 0 = white
Word endianness	Big-endian (Motorola-style)

Core Graphics expects:
MSB-first per byte
0 = black, 1 = white
Byte-oriented scanlines
*/


uint8_t *ConvertPERQBitmap(const uint16_t *src,
                           size_t widthBits,
                           size_t height)
{
    // PERQ scanlines are 64-bit aligned
    size_t wordsPerRow = ((widthBits + 63) & ~63) / 16;
    size_t bytesPerRow = wordsPerRow * 2;

    uint8_t *dst = malloc(bytesPerRow * height);

    for (size_t y = 0; y < height; y++) {
        for (size_t w = 0; w < wordsPerRow; w++) {
            uint16_t word = src[y * wordsPerRow + w];

            // flip polarity
            uint16_t fixed = word ^ 0xFFFF;

            // Store big-endian
            dst[y * bytesPerRow + w * 2 + 0] = fixed >> 8;
            dst[y * bytesPerRow + w * 2 + 1] = fixed & 0xFF;
        }
    }

    return dst;
}


int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s filename - converts PERQ PIC to PNG\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "error opening %s - %d - %s", argv[1], errno, strerror(errno));
        return EXIT_FAILURE;
    }
    unsigned char buffer[1024 * 1024];  // sufficiently big for any perq image file

    read(fd, buffer, sizeof(buffer));

    short width = ((short *)buffer)[0];
    short height = ((short *)buffer)[1];
    short scanLen = ((short *)buffer)[2];
    short blockCount = ((short *)buffer)[3];
    printf("%d %d %d %d\n", width, height, scanLen, blockCount);

    short bytesPerRow = ((width + 63) & ~63) / 8;

    unsigned char *imageDataStart = &buffer[512];  // blocks are 256 words
    
    void *blah = ConvertPERQBitmap((const uint16_t *)imageDataStart, width, height);

    Write1BitBitmapToPNG(blah, width, height, bytesPerRow,
                         @"snork.png");

    return EXIT_SUCCESS;

} // main
