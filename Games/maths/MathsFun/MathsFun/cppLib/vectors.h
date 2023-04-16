#ifndef MATH_VECTORS_H
#define MATH_VECTORS_H

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
    vec2() : x(0.0f), y(0.0f) { }
    vec2(float _x, float _y) : x(_x), y(_y) { }
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

#endif // MATH_VECTORS_H
