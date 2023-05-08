# Maths

Working through _Game Physics Cookbook_ - https://www.packtpub.com/product/game-physics-cookbook/9781787123663

# Notes

## Vectors

* Dot Product: A dot B is a0 * b0 + a1 * b2 + a2 * b2 ...
  - scalar directional relationship between A and B, how much A is pointing in the direction of B
  - if dot product > 0 : vectors point in the same direction
  - if dot product < 0 : vectors point in opposite direction
  - if dot product == 0 : vectors are perpendicular
  - Can also use to find the exact angle between the vectors
    - `dot = |A| |B| cos(theta)`
    - expensive... (ends up needing two square roots and an inverse cosine)

* Magnitude (Length): `|A|`
  - scalar value, essentially distance from origin to the point represented by A
  - also is sqrt(dot(A, A))
  - square roots are expensive, so "squared" flavor is common (so dot(A, A))

* Normalizing: Making a vector in the same direction as a given direction, but a magnitude of 1.0
  - divide each component by the length (magnitude) of the vector
  - equivalent, multiply by the reciprocal
  - notated by V-hat

* Cross Product: `A x B`
  - a new vector perpendicular to A and B
  - just 3D vectors (2D vectors degenerate into a scalar)
  - `(Ay * Bz - Az * By, Ax * Bz - Az * Bx, Ax * By - Ay * Bx)`

* Projection
  - gives the length of A in the direction of B
    - proj-subB-A
      - (A dot B over magnitude(B)-squared) scalar-multiplied to B
      - gives us the parallel component
    - perp-subB-A, which s A - proj-subB-A
      - A minus A dot B / magnitude(B)-squared) scalar-multiplkied to B

* Reflection: Given a vector and a normal, find vector R reflected around the normal
  - R = vector - 2(V dot N-hat)N-hat
    - where N-hat is a unit-length vector
    - (V dot N-hat)N-hat projects V on to N
      - so if N is not normalized, can use -2 projN of V

## Matrices

[PurpleMath](https://www.purplemath.com) under _Advanced Algebra_ was
given as a source of follow-up info(e)

* Basics
  - ixj grid of numbers (# of rows x # of columns)

* Transpose
  - matrix constructed by flipping Mij to Mji

* Determinant
  - used for solving systems of linear equations
  - but for this stuff, use them for finding the inverse of a matrix
    - like, is it invertable at all
    - determinant of zero means not invertable
  - scalar value, `|M|`
  - determinant is the same as the determinant of the transpose
  - subtract the product of the diagonals.

* Minor
  - the determinant of a smaller matrix cut from a larger matrix.
  - matrix of minors by finding the minor for each element of a matrix
  - for a 3x3 matrix, construct the minor by removing row i and column j, then take the determinant
  - for a 2x2 matrix, remove row i and j, and the determinatn is the remaining value.

* Inverted



* Cofactor

* Adjugate
