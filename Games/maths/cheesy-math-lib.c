#import <stdbool.h>
#import <stdio.h>
#import <math.h>

double slopeBetweenPoints(double *P1, double *P2) {
    static const int x = 0, y = 1;

    return (P2[y] - P1[y]) / (P2[x] - P1[x]);

} // slopeBetweenPoints


double orthogonalSlope(double slope) {
    return -1 / slope;
} // orthogonalSlope


bool areSlopesOrthogonal(double slope1, double slope2, double epsilon) {
    printf("%f %f -> %f ... %f\n", slope1, slope2, slope1 * slope2,
        (slope1 * slope2 - -1));
    return (fabs(slope1 * slope2 - -1)) < epsilon;
} // areSlopesOrthogonal



