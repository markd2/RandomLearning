/* cc -g -o vt100 vt100.c */

#include <stdio.h>   /* for printf() */
#include <assert.h>  /* For assert() */

char graphicsChars[] = { 0137, 0140, 0141, 0142, 0143, 0144, 0145,
                         0146, 0147, 0150 };

#define ESC 27

#define ON 1
#define OFF 0


/* From the MarkD Substandard Library */
void grafmode();  /* onoff */
void gotoRC();    /* row, column */
void cls();

/* tile-specific stuffs */

typedef enum TileStatus {
    kStatusIdle,
    kStatusProcessing,
    kStatusFinished,
    kStatusError,

    kStatusCount
} TileStatus;

char *statusDesc[] = {
    "idle", "proc", "fin", "err"
};

typedef struct Tile {
    int nodeNumber;
    TileStatus status;
    char *label;
} Tile;

void drawTile();  /* tile*, row, column */


#define kRowCount 4
#define kColumnCount 8
Tile tiles[kRowCount * kColumnCount];

#define kColumnWidth 10
#define kRowHeight 3

char buffer[1024];  /* icky, I know */

int main(argc, argv)
    int argc;
    char **argv;
{
    int row, column;
    int i;
    int length;
    char *string;

    for (i = 0; i < kRowCount * kColumnCount; i++) {
         tiles[i].nodeNumber = i;
         tiles[i].status = i % kStatusCount;
         length = sprintf(buffer, "%d", i * 17);
         string = (char *)malloc(length + 1);
         string[length] = '\000';
         strcpy(string, buffer);	
         tiles[i].label = string;
    }


    grafmode(ON);

    grafmode(OFF);

    cls();

    for (row = 0; row < kRowCount; row++) {
        for (column = 0; column < kColumnCount; column++) {
            /* kColumnWidth / kRowHeight */
            drawTile(&tiles[row * kColumnCount + column],
                     row * kRowHeight + 1,
                     column * kColumnWidth + 1);
        }
    }

    printf("\n");
    return 0;
}

/* tile's play */

void drawTile(tile, row, column)
    Tile *tile;
    int row;
    int column;
{
    gotoRC(row, column);
    printf("%d: %s", tile->nodeNumber, tile->label);
    gotoRC(row + 1, column);
    printf(" (%s)", statusDesc[tile->status]);
} 

/* MSL below */

void grafmode(onoff)
    int onoff;
{
    assert(onoff == ON || onoff == OFF);

    if (onoff) {
        printf("\033(0");
    } else {
        printf("\033(B");
    }
}

void gotoRC(row, column)
    int row;
    int column;
{
    assert(row > 0 && column > 0);

    printf("\033[%d;%dH", row, column);
}



void cls() {
    printf("\033[2J");
}

/* do some graphics characters */
grafcharTest() {
    int i;
    printf("\033(0");

    for (i = 0; i < sizeof(graphicsChars) / sizeof(*graphicsChars); i++) {
        printf("%d:%c    ", i, graphicsChars[i]);
    }
    printf("\033(B");
}


/* Random grab bag of stuff - like turn on bold / underscore, etc */
grabBag() {

    printf("\033(B\n");   
    printf("org2\n"); 

    printf("\033[0m\033[1mBold\033[4munderscore\033[5mblink\033[7mreverse\n");

    printf("\033#6DoubleWidth\n");
    printf("\033[0m\n"); /* turn off attributts */
} 
