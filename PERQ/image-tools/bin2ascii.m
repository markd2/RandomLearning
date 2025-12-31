#import <Foundation/Foundation.h>
#import <stdio.h>
#import <errno.h>
#import <string.h>

// clang -g -Wall -framework Foundation -o bin2ascii bin2ascii.m

// bin2ascii.m - take a binary file, and generate a PERQ-style ascii interchange
//    file (the format is mine - laughably stupid) - ascii decimal value for each byte
//    on its own line.

// output format is ascii, one byte (decimal) per line.  This is trivial to parse
// from the PERQ Pascal side.
// e.g.
//      137
//       85
//      23
//   ... etc

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "%s input-binary-file output-text-file\n", argv[0]);
        fprintf(stderr, "   convert binary file into PERQ-style text\n");
        fprintf(stderr, "   be sure any line endings are converted PERQstyle with unix2macbefore migrating\n");
        return EXIT_FAILURE;
    }

    int inputBinaryFd = open(argv[1], O_RDONLY);
    if (inputBinaryFd == -1) {
        fprintf(stderr, "error opening %s - %d - %s", argv[1], errno, strerror(errno));
        return EXIT_FAILURE;
    }

    unsigned char buffer[1024 * 1024];  // sufficiently big for any perq image file
    ssize_t len = read(inputBinaryFd, buffer, sizeof(buffer));
    close(inputBinaryFd);

    FILE *outputTextFile = fopen(argv[2], "w");

    unsigned char *scan, *stop;
    scan = buffer;
    stop = scan + len;

    while (scan < stop) {
        fprintf(outputTextFile, "%hhu\n", *scan);
        scan++;
    }
    fclose(outputTextFile);

    return EXIT_SUCCESS;

} // main
