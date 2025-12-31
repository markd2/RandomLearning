x2#import <Foundation/Foundation.h>
#import <stdio.h>

// inhale-perq.m - go from ascii interchange format to a binary file
// be sure to convert newlines with mac2unix

// clang -g -Wall -framework Foundation -o inhale-perq inhale-perq.m


// file format is ascii, one byte (decimal) per line.

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s filename - inhales file (ascii) and emits binary\n",
                argv[0]);
        return EXIT_FAILURE;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        fprintf(stderr, "could not open %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    char buffer[666];
    size_t amountRead;

    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        char blah = (char)atoi(buffer);
        putchar(blah);
        // printf("got %hhx\n", blah);
    }

    return EXIT_SUCCESS;

} // main
