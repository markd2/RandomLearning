# Maths

Working through _Game Physics Cookbook_ - https://www.packtpub.com/product/game-physics-cookbook/9781787123663

# Notes

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
