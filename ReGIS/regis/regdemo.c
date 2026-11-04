#include <stdio.h>
#include <fcntl.h>  /* for open() */

/* switch to ReGIS mode and clear the screen */
static char *prolog = "\033PpS(E)";
static char *terminator = "\033\\";

void usage(); void blortFile();

int main(argc, argv)
    int argc;
    char *argv[];
{
    if (argc != 2) {
        usage();
        printf("%s%s", prolog,  terminator);
        return 0;
    }
    blortFile(argv[1]);
    return 0;

} /* main */


void blortFile(filename)
    char *filename;
{
    char buffer[512];
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "could not open %s\n", filename);
	exit(42);
    }
    printf("%s", prolog);

    do {
        char *line = fgets(buffer, 512, file);
        if (line == NULL) break;
	if (line[0] == '#') continue; /* skip comments */
	fputs(line, stdout);
    } while (1);

    printf("%s", terminator);
} /* blortFile */


void usage() {
    printf("blah filename.rf\n");

} /* usage */
