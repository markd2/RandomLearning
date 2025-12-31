#import <Foundation/Foundation.h>
#import <stdio.h>
#import <errno.h>
#import <string.h>

// ascii2bin.m - go from ascii interchange format to a binary file
// be sure to convert newlines with mac2unix coming in

// clang -g -Wall -framework Foundation -o ascii2bin ascii2bin.m

// file format is ascii, one byte (decimal) per line.  This is trivial to generate
// from the PERQ Pascal side.
// e.g.
//      137
//       85
//      23
//   ... etc


int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "%s input-text-file output-binary-file\n", argv[0]);
        fprintf(stderr, "   convert the ascii file into binary\n");
        fprintf(stderr, "   be sure any PERQ line endings are converted with mac2unix\n");
        return EXIT_FAILURE;
    }

    FILE *inputTextFile = fopen(argv[1], "r");
    if (inputTextFile == NULL) {
        fprintf(stderr, "could not open %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    int outputBinaryFd = open(argv[2], O_RDWR | O_CREAT | O_TRUNC,
                              S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
    if (outputBinaryFd == -1) {
        fprintf(stderr, "could not open %s - %d/%s\n", argv[2], errno, strerror(errno));
        return EXIT_FAILURE;
    }

    char buffer[666];

    while (fgets(buffer, sizeof(buffer), inputTextFile) != NULL) {
        char blah = (char)atoi(buffer);
        write(outputBinaryFd, &blah, sizeof(char));
    }
    
    close(outputBinaryFd);

    return EXIT_SUCCESS;

} // main
