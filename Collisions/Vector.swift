#!/usr/bin/swift

// Vector class, adapted from _Physics for Game Developers, 2nd Edition_ by Borkware

print("hoover")

struct Vector {
    var x: Double
    var y: Double
    var z: Double

    var magnitude: Double {
        (x*x + y*y + z*z).squareRoot()
    }

    init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0) {
        self.x = x
        self.y = y
        self.z = z
    }

    let tolerance = 0.0001

    mutating func normalize() {
        var magnitude = self.magnitude

        if magnitude < tolerance { magnitude = 1.0 }
        x /= magnitude
        y /= magnitude
        z /= magnitude
        
        if x < tolerance { x = 0.0 }
        if y < tolerance { y = 0.0 }
        if z < tolerance { z = 0.0 }
    }

    mutating func reverse() {
        x = -x
        y = -y
        z = -z
    }

    /// Triple Scalar Product - self dotProduct ( v cross w )
    func tripleScalarProduct(_ v: Vector, _ w: Vector) -> Double {
        (x * (v.y * w.z - v.z * w.y)) +
          (y * (-v.x * w.z + v.z * w.x)) +
          (z * (v.x * w.y - v.y * w.x))
    }
    
    static func +(thing1: Vector, thing2: Vector) -> Vector {
        Vector(x: thing1.x + thing2.x,
               y: thing1.y + thing2.y,
               z: thing1.z + thing2.z)
    }

    static func +=(thing1: inout Vector, thing2: Vector) {
        thing1.x += thing2.x
        thing1.y += thing2.y
        thing1.z += thing2.z
    }

    static func -(thing1: Vector, thing2: Vector) -> Vector {
        Vector(x: thing1.x - thing2.x,
               y: thing1.y - thing2.y,
               z: thing1.z - thing2.z)
    }

    static func -=(thing1: inout Vector, thing2: Vector) {
        thing1.x -= thing2.x
        thing1.y -= thing2.y
        thing1.z -= thing2.z
    }

    static func *(thing1: Vector, scalar: Double) -> Vector {
        var vector = thing1
        vector.x *= scalar
        vector.y *= scalar
        vector.z *= scalar
        return vector
    }

    static func *=(thing1: inout Vector, scalar: Double) {
        thing1.x *= scalar
        thing1.y *= scalar
        thing1.z *= scalar
    }

    static func /(thing1: Vector, scalar: Double) -> Vector {
        var vector = thing1
        vector.x /= scalar
        vector.y /= scalar
        vector.z /= scalar
        return vector
    }

    static func /=(thing1: inout Vector, scalar: Double) {
        thing1.x /= scalar
        thing1.y /= scalar
        thing1.z /= scalar
    }

    /// "conjugate"
    static prefix func -(thing1: Vector) -> Vector {
        Vector(x: -thing1.x, y: -thing1.y, z: -thing1.z)
    }

    /// Cross Product
    /// Vector perpendicular to thing1 and thing2
    static func ^(thing1: Vector, thing2: Vector) -> Vector {
        Vector(x: thing1.y * thing2.z - thing1.z * thing2.y,
               y: -thing1.x * thing2.z + thing1.z * thing2.x,
               z: thing1.x * thing2.y - thing1.y * thing2.x)
    }

    /// Dot Product
    /// Projection of thing1 on to thing2
    static func *(thing1: Vector, thing2: Vector) -> Double {
        thing1.x * thing2.x + thing1.y * thing2.y + thing1.z * thing2.z
    }
}

var vector = Vector(x: 1.5, y: 2.7, z: 10.5)

print("vector \(vector)")
print("magnitude \(vector.magnitude)")

print("normalizing")
vector.normalize()
print("magnitude \(vector.magnitude)")
print("vector \(vector)")

print("reversing")
vector.reverse()
print("magnitude \(vector.magnitude)")
print("vector \(vector)")

print("adding")
var vector2 = vector + vector
print("vector2 \(vector2)")

print("equal-adding")
vector2 += vector
print("vector2 \(vector2)")

print("subtracting")
vector2 = vector - vector
print("vector2 \(vector2)")

print("equal-subtracting")
vector2 -= vector
print("vector2 \(vector2)")


print("scalar multiplication")
var vector3 = vector * 23
print("vector3 \(vector3)")

print("scalar equal-multiplication")
vector3 *= 42
print("vector3 \(vector3)")

print("scalar division")
var vector4 = vector / 10
print("vector3 \(vector4)")

print("scalar equal-division")
vector4 /= 2
print("vector4 \(vector4)")

print("conjugate")
print("-vector4 \(-vector4)")

print("cross product")
let x = Vector(x: 1)
let y = Vector(y: 1)
let z = x ^ y
print("x cross y \(z)")

print("dot product")
let vector5 = Vector(x: 5, y: 5, z: 5)
let vector6 = Vector(x: 6, y: 6, z: 6)
let dot = vector5 * vector6
print("5 dot 6 \(dot)")

print("triple scalar product")
let tsp = vector3.tripleScalarProduct(x, y)
print("run/tsp \(tsp)")

