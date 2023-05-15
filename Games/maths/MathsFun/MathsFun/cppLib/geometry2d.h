#ifndef MATH_GEOMETRY_2D
#define MATH_GEOMETRY_2D

#include "vectors.h"
typedef vec2 Point2D;

typedef struct Line2D {
    Point2D start;
    Point2D end;

    inline Line2D() {}
    inline Line2D(const Point2D &s, const Point2D &e): start(s), end(e) {}
} Line2D;

float Length(const Line2D &line);
float LengthSq(const Line2D &line);

#endif // MATH_GEOMETRY_2D

