# Maths

Working through _Game Physics Cookbook_ - https://www.packtpub.com/product/game-physics-cookbook/9781787123663

# Notes

* Dot Product: A dot B is a0 * b0 + a1 * b2 + a2 * b2 ...
  - directional relationship between A and B, how much A is pointing in the direction of B
  - if dot product > 0 : vectors point in the same direction
  - if dot product < 0 : vectors point in opposite direction
  - if dot product == 0 : vectors are perpendicular
  - Can also use to find the exact angle between the vectors
    - `dot = |A| |B| cos(theta)`

* Length: `|A|`
  - essentially distance from origin to the point represented by A
  - also is sqrt(dot(A, A))
  - square roots are expensive, so "squared" flavor is common (so dot(A, A))


