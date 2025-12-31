#import <Foundation/Foundation.h>
#import <stdio.h>
#import <errno.h>
#import <string.h>

// exhale-perc.m - take a binary file, and generate a perc-style ascii interchange
//    file (the format is mine - laughably stupid) - ascii decimal value for each byte
//    on its own line.

// clang -g -Wall -framework Foundation -o exhale-perq exhale-perq.m

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s filename - exhales file (binary) and emits ascii\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "error opening %s - %d - %s", argv[1], errno, strerror(errno));
        return EXIT_FAILURE;
    }
    unsigned char buffer[1024 * 1024];  // sufficiently big for any perq image file

    ssize_t len = read(fd, buffer, sizeof(buffer));

    unsigned char *scan, *stop;
    scan = buffer;
    stop = scan + len;

    while (scan < stop) {
        printf("%hhu\n", *scan);
        scan++;
    }

    return EXIT_SUCCESS;

} // main
