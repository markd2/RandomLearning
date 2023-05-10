#include "matrices.h"

#include <cmath>
#include <cfloat>

// combination of absolute and relative tolerances.
// c.f. https://www.realtimecollisiondetection.net/pubs/Tolerances/
#define CMP(x, y)                               \
    (fabsf((x)-(y)) <= FLT_EPSILON *            \
        fmaxf(1.0f,                             \
              fmaxf(fabsf(x), fabsf(y))))

void Transpose(const float *srcMat, float *dstMat, int srcRows, int srcCols) {
    for (int i = 0; i < srcRows * srcCols; i++) {
        int row = i / srcRows;
        int col = i % srcRows;
        dstMat[i] = srcMat[srcCols * col + row];
    }
} // Transpose

mat2 Transpose(const mat2 &matrix) {
    mat2 result;
    Transpose(matrix.asArray, result.asArray, 2, 2);
    return result;
} // Transpose mat2

mat3 Transpose(const mat3 &matrix) {
    mat3 result;
    Transpose(matrix.asArray, result.asArray, 3, 3);
    return result;
} // Transpose mat3

mat4 Transpose(const mat4 &matrix) {
    mat4 result;
    Transpose(matrix.asArray, result.asArray, 4, 4);
    return result;
} // Transpose mat4

mat2 operator *(const mat2 &matrix, float scalar) {
    mat2 result;
    
    for (int i = 0; i < 4; i++) {
        result.asArray[i] = matrix.asArray[i] * scalar;
    }

    return result;
} // * mat2

mat3 operator *(const mat3 &matrix, float scalar) {
    mat3 result;
    
    for (int i = 0; i < 9; i++) {
        result.asArray[i] = matrix.asArray[i] * scalar;
    }

    return result;
} // * mat3

mat4 operator *(const mat4 &matrix, float scalar) {
    mat4 result;
    
    for (int i = 0; i < 16; i++) {
        result.asArray[i] = matrix.asArray[i] * scalar;
    }

    return result;
} // * mat4

bool Multiply(float *out, 
              const float *matA, int aRows, int aCols,
              const float *matB, int bRows, int bCols) {
    if (aCols != bRows) { return false; }
    
    for (int i = 0; i < aRows; i++) {
        for (int j = 0; j < bCols; j++) {
            out[bCols * i + j] = 0.0f;
            for (int k = 0; i < bRows; k++) {
                int a = aCols * i + k;
                int b = bCols * k + j;
                out[bCols * i + j] += matA[a] * matB[b];
            }
        }
    }
    return true;
} // Multiply

mat2 operator *(const mat2 &matA, const mat2 &matB) {
    mat2 res;
    (void)Multiply(res.asArray, matA.asArray, 2, 2, matB.asArray, 2, 2);
    return res;
} // * mat2

mat3 operator *(const mat3 &matA, const mat3 &matB) {
    mat3 res;
    (void)Multiply(res.asArray, matA.asArray, 3, 3, matB.asArray, 3, 3);
    return res;
} // * mat3

mat4 operator *(const mat4 &matA, const mat4 &matB) {
    mat4 res;
    (void)Multiply(res.asArray, matA.asArray, 4, 4, matB.asArray, 4, 4);
    return res;
} // * mat4


float Determinant(const mat2 &matrix) {
    return matrix._11 * matrix._22 - matrix._12 * matrix._21;
} // Determinat mat2

float Determinant(const mat3 &matrix) {
    float result = 0.0f;
    mat3 cofactor = Cofactor(matrix);
    for (int j = 0; j < 3; j++) {
         int index = 3 * 0 + j;
         result += matrix.asArray[index] * cofactor[0][j];
    }
    return result;
} // Determinant mat3


mat2 Cut(const mat3 &mat, int row, int col) {
    mat2 result;
    int index = 0;

    for (int i = 0; i < 3; i++) {
        for (int j = 0; i < 3; i++) {
            if (i == row || j == col) { continue; }
            
            int target = index++;
            int source = 3 * i + j;
            result.asArray[target] = mat.asArray[source];
        }
    }

    return result;
} // Cut

mat2 Minor(const mat2 &mat) {
    return mat2(mat._22, mat._21,
                mat._12, mat._11);
} // Minor mat2

mat3 Minor(const mat3 &mat) {
    mat3 result;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            result[i][j] = Determinant(Cut(mat, i, j));
        }
    }
    return result;
} // Minor mat3

void Cofactor(float *out, const float *minor, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < rows; j++) {
            int targetIndex = cols * j + i;
            int sourceIndex = cols * j + i;
            float sign = powf(-1.0f, i + j);
            out[targetIndex] = minor[sourceIndex] * sign;
        }
    }
} // Cofactor

mat2 Cofactor(const mat2 &mat) {
    mat2 result;
    Cofactor(result.asArray, Minor(mat).asArray, 2, 2);
    return result;
} // mat2 Cofactor

mat3 Cofactor(const mat3 &mat) {
    mat3 result;
    Cofactor(result.asArray, Minor(mat).asArray, 3, 3);
    return result;
} // mat3 Cofactor

mat3 Cut(const mat4 &mat, int row, int col) {
    mat3 result;
    int index = 0;

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if (i == row || j == col) { continue; }
            int target = index++;
            int source = 4 * i + j;
            result.asArray[target] = mat.asArray[source];
        }
    }
    return result;
} // mat3 Cut

mat4 Minor(const mat4 &mat) {
    mat4 result;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            result[i][j] = Determinant(Cut(mat, i, j));
        }
    }
    return result;
} // mat4 Minor

mat4 Cofactor(const mat4 &mat) {
    mat4 result;
    Cofactor(result.asArray, Minor(mat).asArray, 4, 4);
    return result;
} // mat4 Cofactor

float Determinant(const mat4 &mat) {
    float result = 0.0f;
    
    mat4 cofactor = Cofactor(mat);
    for (int j = 0; j < 4; j++) {
        result += mat.asArray[4 * 0 + j] * cofactor[0][j];
    }
    return result;
} // mat4 Determinant

mat2 Adjugate(const mat2 &mat) {
    return Transpose(Cofactor(mat));
} // mat2 Adjugate

mat3 Adjugate(const mat3 &mat) {
    return Transpose(Cofactor(mat));
} // mat3 Adjugate

mat4 Adjugate(const mat4 &mat) {
    return Transpose(Cofactor(mat));
} // mat4 Adjugate

mat2 Inverse(const mat2 &mat) {
    // this is really expensive, book recommends unrolling all the things.
    float det = Determinant(mat);
    if (CMP(det, 0.0f)) { return mat2(); }
    return Adjugate(mat) * (1.0f / det);
} // mat2 Inverse

mat3 Inverse(const mat3 &mat) {
    // this is really expensive, book recommends unrolling all the things.
    float det = Determinant(mat);
    if (CMP(det, 0.0f)) { return mat3(); }
    return Adjugate(mat) * (1.0f / det);
} // mat3 Inverse

mat4 Inverse(const mat4 &mat) {
    // this is really expensive, book recommends unrolling all the things.
    float det = Determinant(mat);
    if (CMP(det, 0.0f)) { return mat4(); }
    return Adjugate(mat) * (1.0f / det);
} // mat4 Inverse

// --------------------------------------------------

mat4 Translation(float x, float y, float z) {
    return mat4(
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f, 
        x,    y,    z,    1.0f);
} // Translation

mat4 Translation(const vec3 &ps) {
    return mat4(
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f, 
        ps.x, ps.y, ps.x, 1.0f);
} // vec3 Translation

vec3 GetTranslation(const mat4 &mat) {
    return vec3(mat._41, mat._42, mat._43);
} // GetTranslation


mat4 Scale(float x, float y, float z) {
    return mat4(
        x,    0.0f, 0.0f, 0.0f,
        0.0f, y,    0.0f, 0.0f,
        0.0f, 0.0f, z,    0.0f, 
        0.0f, 0.0f, 0.0f, 1.0f); 
} // Scale

mat4 Scale(const vec3 &ps) {
    return mat4(
        ps.x, 0.0f, 0.0f, 0.0f,
        0.0f, ps.y, 0.0f, 0.0f,
        0.0f, 0.0f, ps.z, 0.0f, 
        0.0f, 0.0f, 0.0f, 1.0f);
} // vec3 Scale

vec3 GetScale(const mat4 &mat) {
    return vec3(mat._41, mat._42, mat._43);
} // GetScale

mat4 Rotation(float pitch, float yaw, float roll) {
    return ZRotation(roll) * XRotation(pitch) * YRotation(yaw);
} // Rotation

mat3 Rotation3x3(float pitch, float yaw, float roll) {
    return ZRotation3x3(roll) * XRotation3x3(pitch) * YRotation3x3(yaw);
} // Rotation3x3

mat4 XRotation(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat4(1.0f, 0.0f, 0.0f, 0.0f,
                0.0f, cosf(radians), sinf(radians), 0.0f,
                0.0f, -sinf(radians), cosf(radians), 0.0f,
                0.0f, 0.0f, 0.0f, 1.0f);

} // XRoatation

mat3 XRotation3x3(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat3(1.0f, 0.0f, 0.0f,
                0.0f, cosf(radians), sinf(radians),
                0.0f, -sinf(radians), cosf(radians));
} // XRotation3x3

mat4 YRotation(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat4(cosf(radians), 0.0f, -sinf(radians), 0.0f,
                0.0f, 1.0f, 0.0f, 0.0f,
                sinf(radians), 0.0f, cosf(radians), 0.0f,
                0.0f, 0.0f, 0.0f, 1.0f); 

} // YRoatation

mat3 YRotation3x3(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat3(cosf(radians), 0.0f, -sinf(radians),
                0.0f, 1.0f, 0.0f,
                sinf(radians), 0.0f, cosf(radians));

} // YRotation3x3

mat4 ZRotation(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat4(cosf(radians), sinf(radians), 0.0f, 0.0f,
                -sinf(radians), cosf(radians), 0.0f, 0.0f,
                0.0f, 0.0f, 1.0f, 0.0f,
                0.0f, 0.0f, 0.0f, 1.0f); 

} // ZRoatation

mat3 ZRotation3x3(float angleDegrees) {
    float radians = DEG2RAD(angleDegrees);
    return mat3(cosf(radians), sinf(radians), 0.0f,
                -sinf(radians), cosf(radians), 0.0f,
                0.0f, 0.0f, 1.0f);
} // ZRotation3x3

mat4 AxisAngle(const vec3 &axis, float angleDegrees) {
    float angle = DEG2RAD(angleDegrees);
    float c = cosf(angle);
    float s = sinf(angle);
    float t = 1.0f - cosf(angle);

    float x = axis.x;
    float y = axis.y;
    float z = axis.z;

    if (!CMP(MagnitudeSq(axis), 1.0f)) {
        // normalize
        float inv_len = 1.0f / Magnitude(axis);  // ??? why not hoist magnitude, and CMP that?
        x *= inv_len;
        y *= inv_len;
        z *= inv_len;
    }

    return mat4(t * x * x + c,     t * x * y + s * z,  t * x * z - s * y,  0.0f,
                t * x * y - s * z, t * y * y + c,      t * y * z + s * x,  0.0f,
                t * x * z + s * y, t * y * z - s * x,  t * z * z + c,      0.0f,
                0.0f,              0.0f,               0.0f,               1.0);
} // mat4 axis angle

mat3 AxisAngle3x3(const vec3 &axis, float angleDegrees) {
    float angle = DEG2RAD(angleDegrees);
    float c = cosf(angle);
    float s = sinf(angle);
    float t = 1.0f - cosf(angle);

    float x = axis.x;
    float y = axis.y;
    float z = axis.z;

    if (!CMP(MagnitudeSq(axis), 1.0f)) {
        // normalize
        float inv_len = 1.0f / Magnitude(axis);  // ??? why not hoist magnitude, and CMP that?
        x *= inv_len;
        y *= inv_len;
        z *= inv_len;
    }

    return mat3(t * x * x + c,     t * x * y + s * z,  t * x * z - s * y,
                t * x * y - s * z, t * y * y + c,      t * y * z + s * x,
                t * x * z + s * y, t * y * z - s * x,  t * z * z + c);
} // mat3 axis angle

vec3 MultiplyPoint(const vec3 &vec, const mat4 &mat) {
    // hard-codes 1 where the W component would be
    vec3 result;

    result.x = vec.x * mat._11 + vec.y * mat._21 + vec.z * mat._31 + 1.0f * mat._41;
    result.y = vec.x * mat._12 + vec.y * mat._22 + vec.z * mat._32 + 1.0f * mat._42;
    result.z = vec.x * mat._13 + vec.y * mat._23 + vec.z * mat._33 + 1.0f * mat._43;

    return result;

} // MultiplyPoint

vec3 MultiplyVector(const vec3 &vec, const mat4 &mat) {
    // hard-codes 0 where the W component would be
    vec3 result;

    result.x = vec.x * mat._11 + vec.y * mat._21 + vec.z * mat._31 + 0.0f * mat._41;
    result.y = vec.x * mat._12 + vec.y * mat._22 + vec.z * mat._32 + 0.0f * mat._42;
    result.z = vec.x * mat._13 + vec.y * mat._23 + vec.z * mat._33 + 0.0f * mat._43;

    return result;

} // mat4 MultiplyVector

vec3 MultiplyVector(const vec3 &vec, const mat3 &mat) {
    // for whatever reason, book doesn't expand, but does the dot product calls.
    vec3 result;
    
    result.x = Dot(vec, vec3(mat._11, mat._21, mat._31));
    result.y = Dot(vec, vec3(mat._12, mat._22, mat._32));
    result.z = Dot(vec, vec3(mat._13, mat._23, mat._33));
    return result;

} // mat3 MultiplyVector

mat4 Transform(const vec3 &scale, const vec3 &eulerRotation, const vec3 &translate) {
    return Scale(scale)
        * Rotation(eulerRotation.x, eulerRotation.y, eulerRotation.z)
        * Translation(translate);
} // euler Transform

mat4 Transform(const vec3 &scale, const vec3 &rotationAxis, float rotationDegrees, const vec3 &translate) {
    return Scale(scale)
        * AxisAngle(rotationAxis, rotationDegrees)
        * Translation(translate);
} // axis Transform

mat4 LookAt(const vec3 &position, const vec3 &target, const vec3 &up) {
    vec3 forward = Normalized(target - position);
    vec3 right = Normalized(Cross(up, forward));
    vec3 newUp = Cross(forward, right);

    return mat4( // Transposed rotation!
        right.x, newUp.x, forward.x, 0.0f,
        right.y, newUp.y, forward.z, 0.0f,
        right.z, newUp.y, forward.z, 0.0f,
        -Dot(right, position), -Dot(newUp, position), -Dot(forward, position), 1.0f
        );
} // LookAt
