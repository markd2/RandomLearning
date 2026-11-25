#include <stdio.h>
#include <fcntl.h>  /* for open() */
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/dir.h> /* for opendir() and friends */

extern int errno;

/* Demo program exercising ReGIS GrAPHICS.
 * program arguments:
 *   -m : run in menu-oriented demo mode
 *   -e : erase the screen / reset regis graphics
 *   -s dirname : run an auto-advancing slide show of regis (.rf) files in
 *                the given directory
 *   -i dirname : run interactive slide show with user controls
 *   -f filename : blort that file to the screen and exit
 */

typedef enum {
    pmMenu,       /* -m */
    pmSlideShow,  /* -s directory */
    pmInteractiveSlideShow,  /* -i directory */
    pmErase,      /* -e */
    pmSingle,     /* -f filename */
    pmError
} ProgramMode;

/* switch to ReGIS mode, clear and reset the screen */
/* static char *prolog = "\033PpS(E)"; */
 static char *prolog = "\033PpS(E)T[+9,+0](S1,H2,S[9,20],M[1,2],D0,I0)";
static char *terminator = "\033\\";

void usage(); void blortFile(); void blortDirectory(); void erase();

typedef struct Mode {
    ProgramMode mode;
    char *argument;
} Mode;

Mode arguments(argc, argv)
    int argc;
    char *argv[];
{
    Mode mode;
    char c;

    extern char *optarg;
    extern int optind;
    optind = 1;

    mode.mode = pmError;
    mode.argument = NULL;

    /* I'm ok with technically incorrect commands (e.g. -m -e) - it'll 
     * pick the first one */

    while ((c = getopt(argc, argv, "mei:s:f:")) != EOF) {
        switch (c) {
            case 'm': mode.mode = pmMenu; break;
            case 'e': mode.mode = pmErase; break;
            case 'i': mode.mode = pmInteractiveSlideShow; mode.argument = optarg; break;
            case 's': mode.mode = pmSlideShow; mode.argument = optarg; break;
            case 'f': mode.mode = pmSingle; mode.argument = optarg; break;
            case '?':
            default:
                mode.mode = pmError;
                break;
        }
    }

    return mode;
} /* arguments */


int main(argc, argv)
    int argc;
    char *argv[];
{
    Mode programMode;
    programMode = arguments(argc, argv);

    switch (programMode.mode) {
        case pmSingle: blortFile(programMode.argument); break;
        case pmSlideShow: blortDirectory(programMode.argument); break;
        case pmErase: erase(); break;
        case pmError: printf("ERROR\n"); usage(); break;
    }


    /* blortFile(argv[1]); */
    return 0;

} /* main */


void erase() {
    printf("%s", prolog);
    printf("%s\n", terminator);
} /* erase */


void blortFile(filename)
    char *filename;
{
    char buffer[512];
    FILE *file = fopen(filename, "r");
    printf("%s\n", filename);
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


int hasSuffix(string, suffix)
    char *string;
    char *suffix;
{
    int slen = strlen(string);
    int xlen = strlen(suffix);
    char *sscan, *xscan, *xstop;

    if (xlen > slen) return 0;

    sscan = string + slen - xlen;
    xscan = suffix;
    xstop = xscan + xlen;

    while (xscan < xstop) {
        if (*xscan != *sscan) return 0;
        xscan++;
        sscan++;
    }

    return 1;
} /* hasSuffix */


void blortDirectory(dirname)
    char *dirname;
{
    DIR *dirp;
    int fileCount;
    int result;
    struct direct *entry;
struct fourAcgs *oopack;


    dirp = opendir(dirname);
    if (dirp == NULL) {
        fprintf(stderr, "could not open directory '%s' - errno %d\n", 
                dirname, errno);
        return;
    }

    result = chdir(dirname);
    if (result != 0) {
        fprintf(stderr, "could not chdir to '%s' - errno %d\n",
                dirname, errno);
        return;
    }

    /* for now, just walk in return order.  TODO: sort names first */
    while ((entry = readdir(dirp)) != NULL) {
        printf("%d: %s\n", entry->d_namlen, entry->d_name);
        if (!hasSuffix(entry->d_name, ".rf")) continue;
        blortFile(entry->d_name);
    }
    
    
    closedir(dirp);

} /* blortDirectory */


void usage() {
    printf("Send ReGIS stuff to stdout, which should show graphics on a compatible terminal\n");
    printf("    -f filename  : send a single filename (works)\n");
    printf("    -e           : erase screen / reset ReGIS environment\n");
    printf("    -s dirname   : show *.rf files in directory as a slideshow\n");
    printf("    -i dirname   : interactive slideshow of *.rf files in directory\n");
    printf("    -m           : show menu of computationally-generate ReGIS\n");

} /* usage */
