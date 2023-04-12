#import <stdio.h>
#import <stdbool.h>
#import <stdlib.h> // for qsort_b

#import "cheesy-math-lib.c"

// clang -g -arch arm64 -o lines lines.c

int main(void) {
//    double p1[] = {1, 5};
//    double p2[] = {-2, 0};
//    double m = slopeBetweenPoints(p1, p2);
//    printf("%f\n", m);

    CheesyPoint p1 = { 20, 50 };
    CheesyPoint p2 = { 100, 90 };
    CheesyPoint p3 = { 70, 150 };

    double d1 = cheesyDistance(p1, p2);
    double d2 = cheesyDistance(p2, p3);
    double d3 = cheesyDistance(p3, p1);
    printf("%f %f  -  %f %f - %f %f\n", d1, d1*d1, d2, d2*d2, d3, d3*d3);

    double points[] = { d1, d2, d3 };
    qsort_b(points, sizeof(points) / sizeof(*points), // nel
            sizeof(*points), // width
            ^int(const void *thing1, const void *thing2) {
                double th1 = *(double*)thing1;
                double th2 = *(double*)thing2;
                if (th2 < th1) return -1;
                else if (th1 < th2) return 1;
                else return 0;
            });

    double c = points[0];
    double a = points[1];
    double b = points[2];

    printf("%f = %f + %f (%f)\n", c*c, a*a, b*b, a*a + b*b);

} // main
