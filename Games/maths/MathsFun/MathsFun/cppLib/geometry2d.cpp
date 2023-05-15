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

bool PointOnLine(const Point2D &point, const Line2D &line) {
    float dx = line.end.x - line.start.x;
    float dy = line.end.y - line.start.y;
    float m = dy / dx;
    float b = line.start.y - m * line.start.x;
    return CMP(point.y, m * point.x + b);
} // PointOnLine

bool PointInCircle(const Point2D &point, const Circle &circle) {
    Line2D line(point, circle.position);
    if (LengthSq(line) < circle.radius * circle.radius) {
        return true;
    }
    return false;
} // PointInCircle

bool PointInRectangle(const Point2D &point, const Rectangle2D &rectangle) {
    vec2 min = GetMin(rectangle);
    vec2 max = GetMax(rectangle);

    return min.x <= point.x
        && min.y <= point.y
        && point.x <= max.x
        && point.y <= max.y;
    return false;
} // PointInRectangle

bool PointInOrientedRectangle(const Point2D &point, const OrientedRectangle &rectangle) {
    vec2 rotVector = point - rectangle.position;
    float theta = -DEG2RAD(rectangle.rotation);
    float zRotation2x2[] = {
        cosf(theta), sinf(theta),
        -sinf(theta), cosf(theta)
    };
    Multiply(rotVector.asArray,
             vec2(rotVector.x, rotVector.y).asArray, 1, 2,  // array/rows/cols
             zRotation2x2, 2, 2);
    Rectangle2D localRectangle(Point2D(), rectangle.halfExtents * 2.0f);
    vec2 localPoint = rotVector + rectangle.halfExtents;
    return PointInRectangle(localPoint, localRectangle);
} // PointInOrientedRectangle

