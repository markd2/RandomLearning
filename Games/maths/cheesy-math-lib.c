#import "cheesy-math-lib.h"

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


CheesySlopeInterceptLine slopeInterceptFromPoints(CheesyPoint p1, CheesyPoint p2) {

    // point-slope form is
    //   (y - p1.y) = m(x - p1.x)

    double m = slopeBetweenPoints((double*)&p1, (double*)&p2);

    // y = p1.y + m(x - p1.x)
    // eval y intercept from this
    double b = p1.y + m * (0 - p1.x);

    // y = m(x + p1.x) + b

    CheesySlopeInterceptLine line = { m, b };
    return line;

} // slopeInterceptFromPoints


double evalYForSlopeIntercept(CheesySlopeInterceptLine line, double x) {
    return line.slope * x + line.yIntercept;
} // evalYForSlopeIntercept
