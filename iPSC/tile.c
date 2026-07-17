/* cc -g -o vt100 vt100.c */

#include <stdio.h>   /* for printf() */
#include <assert.h>  /* For assert() */

/* From the MarkD Substandard Library */
#define ON 1
#define OFF 0

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
void drawAllTheTiles();

#define kRowCount 4
#define kColumnCount 8
Tile tiles[kRowCount * kColumnCount];

#define kColumnWidth 10
#define kRowHeight 4

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


    cls();

    for (i = 0; i < 20; i++) {
        int j;

        drawAllTheTiles();
        for (j = 0; j < 8; j++) {
            tiles[random() % (kRowCount * kColumnCount)].status = random() % kStatusCount;
        }    
        sleep(1);
    } 

    printf("\n\n\n");
    return 0;
}

void drawAllTheTiles() {
    int row, column;

    for (row = 0; row < kRowCount; row++) {
        for (column = 0; column < kColumnCount; column++) {
            drawTile(&tiles[row * kColumnCount + column],
                     row * kRowHeight + 1,
                     column * kColumnWidth + 1);
        }
    }

    gotoRC(kRowCount * kRowHeight + 2, 1);
    fflush(stdout);
}

/* tile's play */

void drawTile(tile, row, column)
    Tile *tile;
    int row;
    int column;
{
    grafmode(ON); {
        gotoRC(row, column);
        printf("lqqqqqqqqk");
        gotoRC(row+1, column);
        printf("x        x");
        gotoRC(row+2, column);
        printf("x        x");
        gotoRC(row+3, column);
        printf("mqqqqqqqqj");
    } grafmode(OFF);

    gotoRC(row + 1, column + 1);
    printf("%d: %s", tile->nodeNumber, tile->label);
    gotoRC(row + 2, column + 2);
    printf("(%s)", statusDesc[tile->status]);
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
