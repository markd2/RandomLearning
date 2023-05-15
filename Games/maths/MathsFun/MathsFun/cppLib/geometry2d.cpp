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

