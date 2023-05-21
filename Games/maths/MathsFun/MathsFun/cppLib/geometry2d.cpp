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

bool LineCircle(const Line2D &line, const Circle &circle) {
    vec2 ab = line.end - line.start;
    float t = Dot(circle.position - line.start, ab) / Dot(ab, ab);
    if (t < 0.0f || t > 1.0f) {
        return false;
    }
    Point2D closestPoint = line.start + ab * t;
    Line2D circleToClosest(circle.position, closestPoint);
    return LengthSq(circleToClosest) < circle.radius * circle.radius;
} // LineCircle

bool LineRectangle(const Line2D &line, const Rectangle2D &rectangle) {
    if (PointInRectangle(line.start, rectangle) || PointInRectangle(line.end, rectangle)) {
        return true;
    }

    vec2 norm = Normalized(line.end - line.start);
    norm.x = (norm.x != 0) ? 1.0f / norm.x : 0;
    norm.y = (norm.y != 0) ? 1.0f / norm.x : 0;

    vec2 min = (GetMin(rectangle) - line.start) * norm;
    vec2 max = (GetMax(rectangle) - line.start) * norm;

    float tmin = fmaxf(
        fminf(min.x, max.x), fminf(min.y, max.y));
    float tmax = fminf(
        fmaxf(min.x, max.x), fmaxf(min.y, max.y));
    if (tmax < 0 || tmin > tmax) {
        return false;
    }

    float t = (tmin < 0.0f) ? tmax : tmin;
    return t > 0.0f && t * t < LengthSq(line);
} // LineRectangle

bool LineOrientedRectangle(const Line2D &line, const OrientedRectangle &rectangle) {
    float theta = -DEG2RAD(rectangle.rotation);
    float zRotation2x2[] = {
        cosf(theta), sinf(theta),
        -sinf(theta), cosf(theta)
    };
    Line2D localLine;

    vec2 rotVector = line.start - rectangle.position;
    Multiply(rotVector.asArray,
             vec2(rotVector.x, rotVector.y).asArray,
             1, 2, zRotation2x2, 2, 2);
    localLine.start = rotVector + rectangle.halfExtents;

    rotVector = line.end - rectangle.position;
    Multiply(rotVector.asArray,
             vec2(rotVector.x, rotVector.y).asArray,
             1, 2, zRotation2x2, 2, 2);
    localLine.end = rotVector + rectangle.halfExtents;

    Rectangle2D localRectangle(Point2D(), rectangle.halfExtents * 2.0f);
    return LineRectangle(localLine, localRectangle);

} // LineOrientedRectangle

bool CircleCircle(const Circle &c1, const Circle &c2) {
    Line2D line(c1.position, c2.position);
    float radiiSum = c1.radius + c2.radius;

    return LengthSq(line) <= radiiSum * radiiSum;
} // CircleCircle


bool CircleRectangle(const Circle &circle, const Rectangle2D &rectangle) {
    vec2 min = GetMin(rectangle);
    vec2 max = GetMax(rectangle);

    // find closest point on the rectangle
    Point2D closestPoint = circle.position;
    if (closestPoint.x < min.x) {
        closestPoint.x = min.x;
    }
    else if (closestPoint.x > max.x) {
        closestPoint.x = max.x;
    }

    if (closestPoint.y < min.y) {
        closestPoint.y = min.y;
    }
    else if (closestPoint.y > max.y) {
        closestPoint.y = max.y;
    }

    Line2D line(circle.position, closestPoint);
    return LengthSq(line) <= circle.radius * circle.radius;

} // CircleRectangle

bool CircleOrientedRectangle(const Circle &circle, const OrientedRectangle &rectangle) {
    vec2 r = circle.position - rectangle.position;
    float theta = -DEG2RAD(rectangle.rotation);
    float zRotation2x2[] = {
        cosf(theta), sinf(theta),
        -sinf(theta), cosf(theta)
    };

    Multiply(r.asArray, vec2(r.x, r.y).asArray, 1, 2,
             zRotation2x2, 2, 2);
    Circle localCircle(r + rectangle.halfExtents, circle.radius);
    Rectangle2D localRect(Point2D(), rectangle.halfExtents * 2.0f);

    return CircleRectangle(localCircle, localRect);

} // CircleOrientedRectangle
