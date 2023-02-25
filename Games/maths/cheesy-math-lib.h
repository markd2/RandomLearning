#ifndef CHEESY_MATH_LIB_H
#define CHEESY_MATH_LIB_H

#import <stdbool.h>

/// Slope is delta y over delta x, so 
///     p2.y - p1.y 
///     -----------
///     p2.x - p1.x
double slopeBetweenPoints(double *P1, double *P2);

/// Orthogonal line slopes have a negative recriprocal relationship,
/// that is, m1 * m2 == -1 if the two slopes are perpendicular
double orthogonalSlope(double slope);

/// are the two slopes orthogonal?
bool areSlopesOrthogonal(double slope1, double slope2, double epsilon);

typedef struct CheesySlopeInterceptLine {
    double slope;
    double yIntercept;
} CheesySlopeInterceptLine;

// because I'm lame, this needs to be castable to a (double *)
typedef struct CheesyPoint {
    double x;
    double y;
} CheesyPoint;

CheesySlopeInterceptLine slopeInterceptFromPoints(CheesyPoint p1, CheesyPoint p2);
double evalYForSlopeIntercept(CheesySlopeInterceptLine line, double x);

#endif // CHEESY_MATH_LIB_H
