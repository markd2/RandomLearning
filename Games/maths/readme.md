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
  - Laplace Expansion:
     - loop through the first row, multiply each elemet with the respective element of the cofactor matrix.
     - first row is arbitary, can do this with any row of the matrix(!)

* Minor
  - the determinant of a smaller matrix cut from a larger matrix.
  - matrix of minors by finding the minor for each element of a matrix
  - for a 3x3 matrix, construct the minor by removing row i and column j, then take the determinant
  - for a 2x2 matrix, remove row i and j, and the determinatn is the remaining value.

* Cofactor
  - take the minor of the matrix, then multiply each i,j with -1 raised
    to the i+j power (basically a +1 / -1 checkerboard pattern)

* Adjugate
  - the transpose of the cofactor matrix
  - a.k.a. adjoint
  - (I think they're just trolling us on these names)

* Inverted
  - the inverse (M-1), when multiplied to the original matrix, yields the
    identity matrix.
  - only square matrices with non-zero determinants can be inverted.
  - to calcuate, 1/|M| and then use that to scalar multiply the adjugate

## Matrix Transformations

The book is using row-major matrices - kind of a toss up if row-major or
column-major is used, but with row-major, each scale vector is stored
horizontally, and so is contiguous in memory.

so, given a 4x4 matrix like this

```
11 12 13 | 14
21 22 23 | 24
31 32 33 | 34
---------+---
41 42 43 | 44
```

* Translation is the bottom vector (41 42 43)
* Scaling is the diagonal (11 22 33)
* Rotation is the 3x3, anchored between 11-33
    - scaling and rotation share values, so they can get intertwingled
    - stored as roll (around z axis), pitch (around x axis), and yaw (around y axis)
      - these are "euler angles" (if I'm getting the terminology correct)
    - can result in gimbal lock, if two or more axes align, resulting in a loss of a degree of rotational freedom.
    - gimbal lock can be avoided with _angle axis matrices_ later in the chapter.