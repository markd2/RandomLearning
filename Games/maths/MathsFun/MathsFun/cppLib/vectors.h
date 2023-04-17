#ifndef MATH_VECTORS_H
#define MATH_VECTORS_H

#define RAD2DEG(x) ((x) * 57.295754f)
#define DEG2RAD(x) ((x) * 0.0174533f)

typedef struct vec2 {
    union {
        struct {
            float x;
            float y;
        };
        float asArray[2];
    };

    float &operator[](int i) {
        return asArray[i];
    }

    vec2() : x(0.0f), y(0.0f) { }
    vec2(float _x, float _y) : x(_x), y(_y) { }
} vec2;


typedef struct vec3 {
    union {
        struct {
            float x;
            float y;
            float z;
        };
        float asArray[3];
    };

    float &operator[](int i) {
        return asArray[i];
    }
    vec3() : x(0.0f), y(0.0f), z(0.0f) { }
    vec3(float _x, float _y, float _z) : x(_x), y(_y), z(_z) { }
} vec3;

vec2 operator+(const vec2 &lhs, const vec2 &rhs);
vec3 operator+(const vec3 &lhs, const vec3 &rhs);
vec2 operator-(const vec2 &lhs, const vec2 &rhs);
vec3 operator-(const vec3 &lhs, const vec3 &rhs);
vec2 operator*(const vec2 &lhs, const vec2 &rhs); // piecewise multiplication
vec3 operator*(const vec3 &lhs, const vec3 &rhs);
vec2 operator*(const vec2 &lhs, float r); // sclar multiplication
vec3 operator*(const vec3 &lhs, float r);
bool operator==(const vec2 &lhs, const vec2 &rhs);
bool operator==(const vec3 &lhs, const vec3 &rhs);
bool operator!=(const vec2 &lhs, const vec2 &rhs);
bool operator!=(const vec3 &lhs, const vec3 &rhs);

float Dot(const vec2 &lhs, const vec2 &rhs);
float Dot(const vec3 &lhs, const vec3 &rhs);

float Magnitude(const vec2 &v);
float Magnitude(const vec3 &v);

float MagnitudeSq(const vec2 &v);
float MagnitudeSq(const vec3 &v);

// treating vectors as points
float Distance(const vec2 &pt1, const vec2 &pt2);
float Distance(const vec3 &pt1, const vec3 &pt2);

void Normalize(vec2 &v);
void Normalize(vec3 &v);

vec2 Normalized(vec2 &v);
vec3 Normalized(vec3 &v);

vec3 Cross(const vec3 &lhs, const vec3 &rhs);

float Angle(const vec2 &lhs, const vec2 &rhs);
float Angle(const vec3 &lhs, const vec3 &rhs);

vec2 Project(const vec2 &length, const vec2 &direction);
vec3 Project(const vec3 &length, const vec3 &direction);

vec2 Perpendicular(const vec2 &length, const vec2 &direction);
vec3 Perpendicular(const vec3 &length, const vec3 &direction);

#endif // MATH_VECTORS_H
