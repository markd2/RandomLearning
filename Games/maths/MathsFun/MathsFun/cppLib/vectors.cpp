#include "vectors.h"

#include <cmath>
#include <cfloat>

// combination of absolute and relative tolerances.
// c.f. https://www.realtimecollisiondetection.net/pubs/Tolerances/
#define CMP(x, y)                               \
    (fabsf((x)-(y)) <= FLT_EPSILON *            \
        fmaxf(1.0f,                             \
              fmaxf(fabsf(x), fabsf(y))))


vec2 operator+(const vec2 &lhs, const vec2 &rhs) {
    return { lhs.x + rhs.x, lhs.y + rhs.y };
} // operator+ vec2

vec3 operator+(const vec3 &lhs, const vec3 &rhs) {
    return { lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z };
} // operator+ vec3


vec2 operator-(const vec2 &lhs, const vec2 &rhs) {
    return { lhs.x - rhs.x, lhs.y - rhs.y };
} // operator- vec2

vec3 operator-(const vec3 &lhs, const vec3 &rhs) {
    return { lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z };
} // operator- vec3


vec2 operator*(const vec2 &lhs, const vec2 &rhs) {
    return { lhs.x * rhs.x, lhs.y * rhs.y };
} // operator* vec2

vec3 operator*(const vec3 &lhs, const vec3 &rhs) {
    return { lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z };
} // operator* vec3


vec2 operator*(const vec2 &lhs, float r) {
    return { lhs.x * r, lhs.y * r };
} // operator* scalar

vec3 operator*(const vec3 &lhs, float r) {
    return { lhs.x * r, lhs.y * r, lhs.z * r };
} // operator* scalar


bool operator==(const vec2 &lhs, const vec2 &rhs) {
    return CMP(lhs.x, rhs.x) && CMP(lhs.y, rhs.y);
} // operator== vec2

bool operator==(const vec3 &lhs, const vec3 &rhs) {
    return CMP(lhs.x, rhs.x) && CMP(lhs.y, rhs.y) && CMP(lhs.z, rhs.z);
} // operator== vec3

bool operator!=(const vec2 &lhs, const vec2 &rhs) {
    return !(lhs == rhs);
} // operator!= vec2

bool operator!=(const vec3 &lhs, const vec3 &rhs) {
    return !(lhs == rhs);
} // operator!= vec3

float Dot(const vec2 &lhs, const vec2 &rhs) {
    return lhs.x * rhs.x + lhs.y * rhs.y;
} // Dot vec2

float Dot(const vec3 &lhs, const vec3 &rhs) {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;;
} // Dot vec3

float Magnitude(const vec2 &v) {
    return sqrtf(Dot(v, v));
} // magnitude vec2

float Magnitude(const vec3 &v) {
    return sqrtf(Dot(v, v));
} // magnitude vec3

float MagnitudeSq(const vec2 &v) {
    return Dot(v, v);
} // magnitudeSq vec2

float MagnitudeSq(const vec3 &v) {
    return Dot(v, v);
} // magnitudeSq vec3

float Distance(const vec2 &pt1, const vec2 &pt2) {
    vec2 connector = pt1 - pt2;
    return Magnitude(connector);
} // Distance (vec2)

float Distance(const vec3 &pt1, const vec3 &pt2) {
    vec3 connector = pt1 - pt2;
    return Magnitude(connector);
} // Distance (vec3)

void Normalize(vec2 &v) {
    v = v * (1.0f / Magnitude(v));
} // Normalize (vec2)

void Normalize(vec3 &v) {
    v = v * (1.0f / Magnitude(v));
} // Normalize (vec3)

vec2 Normalized(vec2 &v) {
    return v * (1.0f / Magnitude(v));
} // Normalizd (vec2)

vec3 Normalized(vec3 &v) {
    return v * (1.0f / Magnitude(v));
} // Normalizd (vec3)
