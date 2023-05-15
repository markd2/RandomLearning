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

typedef struct Circle {
    Point2D position;
    float radius;

    inline Circle() : radius(1.0f) { }
    inline Circle(const Point2D &p, float r) : position(p), radius(r) { }
} Circle;

typedef struct Rectangle2D {
    Point2D origin;
    vec2 size;

    inline Rectangle2D() : size(1, 1) { }
    inline Rectangle2D(const Point2D &o, const vec2 &s) : origin(o), size(s) { }

} Rectangle2D;

Rectangle2D FromMinMax(const vec2 &min, const vec2 &max);

#endif // MATH_GEOMETRY_2D

