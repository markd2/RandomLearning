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



