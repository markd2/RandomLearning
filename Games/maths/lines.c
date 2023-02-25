#import <stdio.h>
#import <stdbool.h>

// clang -g -arch arm64 -o lines lines.c

/// Slope is delta y over delta x, so 
///     p2.y - p1.y 
///     -----------
///     p2.x - p1.x
float slopeBetweenPoints(float *P1, float *P2) {
    static const int x = 0, y = 1;

    return (P2[y] - P1[y]) / (P2[x] - P1[x]);

} // slopeBetweenPoints


/// Orthogonal line slopes have a negative recriprocal relationship,
/// that is, m1 * m2 == -1 if the two slopes are perpendicular
float orthogonalSlope(float slope) {
    return -1 / slope;
} // orthogonalSlope


// are the two slopes orthogonal?
bool areSlopesOrthogonal(float slope1, float slope2) {
    return slope1 * slope2 == -1;
} // areSlopesOrthogonal


int main(void) {
    float p1[] = {1, 5};
    float p2[] = {-2, 0};

    float m = slopeBetweenPoints(p1, p2);

    printf("%f\n", m);
} // main
