#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// clang -g -Wall -framework Foundation -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o pic2png pic2png.m

// take a perq "PIC" format and convert it to PNG so it can read by mac image
// editing tools.

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

void saveBitmapToPNG(const void *bitmapData,
                     size_t width,
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
        width,
        height,
        1,             // bits per component
        1,             // bits per pixel
        bytesPerRow,
        colorSpace,
        bitmapInfo,
        provider,
        NULL,          // decode
        false,         // should interpolate
        kCGRenderingIntentDefault
    );

    if (!image) {
        NSLog(@"could not create image");
        CGDataProviderRelease(provider);
        return;
    }

    // Get set up to write to the output path
    NSURL *url = [NSURL fileURLWithPath: outputPath];
    CGImageDestinationRef destination =
        CGImageDestinationCreateWithURL(
            (__bridge CFURLRef)url,
            (CFStringRef)UTTypePNG.identifier,
            1,    // count
            NULL  // options
        );

    CGImageDestinationAddImage(destination, image, NULL /*properties*/);

    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write PNG");
    }

    CFRelease(destination);
    CGImageRelease(image);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
} // saveBitmapToPNG


// jiggle the bytes around so that making a PNG from the bucket of bits
// has the pixels in the correct order.
uint8_t *byteswapPERQBitmap(const uint16_t *src,
                            size_t width,
                            size_t height)
{
    // PERQ scanlines are 64-bit aligned
    size_t wordsPerRow = ((width + 63) & ~63) / 16;
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

} // byteswapPERQBitmap


int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "%s input-perq-pic-binary output-png\n", argv[0]);
        fprintf(stderr, "   convert PERQ PIC binary image into a PNG\n");
        return EXIT_FAILURE;
    }

    int inputPicFd = open(argv[1], O_RDONLY);
    if (inputPicFd == -1) {
        fprintf(stderr, "error opening %s - %d - %s", argv[1], errno, strerror(errno));
        return EXIT_FAILURE;
    }
    unsigned char buffer[1024 * 1024];  // sufficiently big for any perq image file

    read(inputPicFd, buffer, sizeof(buffer));
    close(inputPicFd);

    // Trust the file, for better or worse
    short width = ((short *)buffer)[0];
    short height = ((short *)buffer)[1];
    short scanLen = ((short *)buffer)[2];
    // short blockCount = ((short *)buffer)[3];  // we really don't need this

    short bytesPerRow = ((width + 63) & ~63) / 8;
    if (scanLen != bytesPerRow / 2) {
        fprintf(stderr, "scan length is sus - calc %d and from file %d\n",
                bytesPerRow, scanLen);
    }

    unsigned char *imageDataStart = &buffer[512];  // blocks are 256 words
    
    void *blah = byteswapPERQBitmap((const uint16_t *)imageDataStart, width, height);

    saveBitmapToPNG(blah, width, height, bytesPerRow, @(argv[2]));

    return EXIT_SUCCESS;

} // main
