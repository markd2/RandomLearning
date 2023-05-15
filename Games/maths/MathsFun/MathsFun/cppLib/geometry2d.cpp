#include "geometry2d.h"
#include "matrices.h"
#include <cmath>
#include <cfloat>

// combination of absolute and relative tolerances.
// c.f. https://www.realtimecollisiondetection.net/pubs/Tolerances/
#define CMP(x, y)                               \
    (fabsf((x)-(y)) <= FLT_EPSILON *            \
        fmaxf(1.0f,                             \
              fmaxf(fabsf(x), fabsf(y))))

float Length(const Line2D &line) {
    return Magnitude(line.end - line.start);
} // Length

float LengthSq(const Line2D &line) {
    return MagnitudeSq(line.end - line.start);
} // LengthSq

vec2 GetMin(const Rectangle2D &rect) {
    vec2 p1 = rect.origin;
    vec2 p2 = rect.origin + rect.size;
    return vec2(fminf(p1.x, p2.x), fminf(p1.y, p2.y));
} // GetMin

vec2 GetMax(const Rectangle2D &rect) {
    vec2 p1 = rect.origin;
    vec2 p2 = rect.origin + rect.size;
    return vec2(fmaxf(p1.x, p2.x), fmaxf(p1.y, p2.y));
} // GetMax

Rectangle2D FromMinMax(const vec2 &min, const vec2 &max) {
    return Rectangle2D(min, max - min);
} // FromMinMax

