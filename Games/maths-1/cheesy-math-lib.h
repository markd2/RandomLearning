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

// --------------------------------------------------

// because I'm lame, this needs to be castable to a (double *)
typedef struct CheesyPoint {
    double x;
    double y;
} CheesyPoint;

double cheesySlopeBetweenPoints(CheesyPoint cp1, CheesyPoint cp2);
double cheesyDistance(CheesyPoint cp1, CheesyPoint cp2);

CheesyPoint cheesyMidpoint(CheesyPoint cp1, CheesyPoint cp2);

// --------------------------------------------------

typedef struct CheesySlopeInterceptLine {
    double slope;
    double yIntercept;
} CheesySlopeInterceptLine;

CheesySlopeInterceptLine slopeInterceptFromPoints(CheesyPoint p1, CheesyPoint p2);
double evalYForSlopeIntercept(CheesySlopeInterceptLine line, double x);

// --------------------------------------------------

typedef struct CheesyPointSlopeLine {
    CheesyPoint point;
    double slope;
} CheesyPointSlopeLine;

CheesyPointSlopeLine pointSlopeFromPoints(CheesyPoint p1, CheesyPoint p2);
double evalYForPointSlope(CheesyPointSlopeLine line, double x);

CheesyPoint intersectionPointOfLines(CheesyPointSlopeLine line1,
                                     CheesyPointSlopeLine line2);


typedef enum CheesyLineIntersectionType {
    kLineIntersects, // slopes differ so one point of intersection
    kLineOverlaps,   // slopes same, y-intercept the same, so overlapping
    kLineParallel    // slopes sane, y-intercept different, so parallel
} CheesyLineIntersectionType;


CheesyLineIntersectionType intersectionTypeOf(CheesySlopeInterceptLine line1,
                                              CheesySlopeInterceptLine line2,
                                              double epsilon);


#endif // CHEESY_MATH_LIB_H
