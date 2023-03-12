#import "cheesy-math-lib.h"

#import <stdio.h>
#import <math.h>


double cheesyDistance(CheesyPoint cp1, CheesyPoint cp2) {
    double distance = sqrt(pow(cp2.x - cp1.x, 2) +
                           pow(cp2.y - cp1.y, 2));
    return distance;
} // cheesyDistance


double cheesySlopeBetweenPoints(CheesyPoint cp1, CheesyPoint cp2) {
    // division by zero? YOLO
    return (cp2.y - cp1.y) / (cp2.x / cp1.y);
}


double slopeBetweenPoints(double *P1, double *P2) {
    static const int x = 0, y = 1;

    return (P2[y] - P1[y]) / (P2[x] - P1[x]);

} // slopeBetweenPoints


double orthogonalSlope(double slope) {
    return -1 / slope;
} // orthogonalSlope


bool areSlopesOrthogonal(double slope1, double slope2, double epsilon) {
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


CheesyPointSlopeLine pointSlopeFromPoints(CheesyPoint p1, CheesyPoint p2) {
    double m = cheesySlopeBetweenPoints(p1, p2);

    CheesyPointSlopeLine line = { .point = p1, .slope = m };

    return line;
} // pointSlopeFromPoints


double evalYForPointSlope(CheesyPointSlopeLine line, double x) {
    return 0;
} // evalYForPointSlope



CheesyLineIntersectionType intersectionTypeOf(CheesySlopeInterceptLine line1,
                                              CheesySlopeInterceptLine line2,
                                              double epsilon) {
    // see if slopes differ
    if (fabs(line1.slope - line2.slope) > epsilon) {
        return kLineIntersects;

    } else {
        // same slope
        if (fabs(line1.yIntercept - line2.yIntercept) < epsilon) {
            // same yIntercept
            return kLineOverlaps;
        } else {
            return kLineParallel;
        }
    }

} // intersectionTypeOf
