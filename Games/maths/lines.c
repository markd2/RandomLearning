#import <stdio.h>
#import <stdbool.h>

#import "cheesy-math-lib.c"

// clang -g -arch arm64 -o lines lines.c

int main(void) {
    double p1[] = {1, 5};
    double p2[] = {-2, 0};

    double m = slopeBetweenPoints(p1, p2);

    printf("%f\n", m);
} // main
