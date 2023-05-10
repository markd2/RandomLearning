import Foundation

private func multiply(matA: [Double], aRows: Int, aCols: Int,
                      matB: [Double], bRows: Int, bCols: Int) -> [Double] {
    if (aCols != bRows) { return [] }
    
    var out = [Double](repeating: 0.0, count: aRows * bCols)
    for i in 0 ..< aRows {
        for j in 0 ..< bCols {
            out[bCols * i + j] = 0.0
            for k in 0 ..< bRows {
                let a = aCols * i + k
                let b = bCols * k + j
                out[bCols * i + j] += matA[a] * matB[b]
            }
        }
    }
    return out
}

struct Mat2: Equatable {
    fileprivate(set) var asArray: [Double]
    var _11: Double {
        asArray[0]
    }
    var _12: Double {
        asArray[1]
    }
    var _21: Double {
        asArray[2]
    }
    var _22: Double {
        asArray[3]
    }

    init() {
        self.asArray = [1, 0,
                        0, 1]
    }
    
    init(_ contents: Double...) {
        var stuff: [Double] = []
        for i in 0 ..< 4 {
            stuff.append(contents[i])
        }
        self.init(stuff)
    }

    init(_ contents: [Double]) {
        self.asArray = contents
    }

    /// Call with blah[0, 1] rather than blah[0][1]
    subscript(row: Int, column: Int) -> Double {
        get {
            asArray[row * 2 + column]
        }

        set {
            asArray[row * 2 + column] = newValue
        }
    }

    func transposed() -> Mat2 {
        let srcRows = 2
        let srcCols = 2
        var contents = self.asArray
        for i in 0 ..< srcRows * srcCols {
            let row = i / srcRows
            let col = i % srcRows
            contents[i] = asArray[srcCols * col + row]
        }
        return Mat2(contents)
    }

    var determinant: Double {
        _11 * _22 - _12 * _21
    }

    func minor() -> Mat2 {
        Mat2(_22, _21, _12, _11)
    }

    func cofactor() -> Mat2 {
        var minor = minor()
        for i in 0 ..< 2 {
            for j in 0 ..< 2 {
                minor[i, j] *= pow(-1.0, Double(i + j))
            }
        }
        
        return minor
    }

    func adjugate() -> Mat2 {
        cofactor().transposed()
    }

    func inverse() -> Mat2 {
        let det = determinant
        guard !absRelFPCompare(det, 0) else {
            return Mat2()
        }
        return adjugate() * (1.0 / det)
    }

    static func *(lhs: Mat2, rhs: Double) -> Mat2 {
        var result = lhs
        result.asArray = result.asArray.map { $0 * rhs }
        return result
    }
    
    static func *(lhs: Mat2, rhs: Mat2) -> Mat2 {
        let guts = multiply(matA: lhs.asArray, aRows: 2, aCols: 2,
                            matB: rhs.asArray, bRows: 2, bCols: 2)
        let m = Mat2(guts)
        return m
    }
    
} // Mat2


struct Mat3: Equatable {
    fileprivate(set) var asArray: [Double]
    var _11: Double {
        asArray[0]
    }
    var _12: Double {
        asArray[1]
    }
    var _13: Double {
        asArray[2]
    }
    var _21: Double {
        asArray[3]
    }
    var _22: Double {
        asArray[4]
    }
    var _23: Double {
        asArray[5]
    }
    var _31: Double {
        asArray[6]
    }
    var _32: Double {
        asArray[7]
    }
    var _33: Double {
        asArray[8]
    }

    /// Call with blah[0, 1] rather than blah[0][1]
    subscript(row: Int, column: Int) -> Double {
        get {
            asArray[row * 3 + column]
        }

        set {
            asArray[row * 3 + column] = newValue
        }
    }

    init() {
        self.asArray = [1, 0, 0, 
                        0, 1, 0, 
                        0, 0, 1]
    }
    
    init(_ contents: Double...) {
        var stuff: [Double] = []
        for i in 0 ..< 9 {
            stuff.append(contents[i])
        }
        self.init(stuff)
    }

    init(_ contents: [Double]) {
        self.asArray = contents
    }

    func transposed() -> Mat3 {
        let srcRows = 3
        let srcCols = 3
        var contents = self.asArray
        for i in 0 ..< srcRows * srcCols {
            let row = i / srcRows
            let col = i % srcRows
            contents[i] = asArray[srcCols * col + row]
        }
        return Mat3(contents)
    }

    func cut(row: Int, column: Int) -> Mat2 {
        var result = Mat2()
        var index = 0

        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                guard i != row && j != column else { continue }
                let target = index
                index += 1  // index++ lolsob
                let source = 3 * i + j
                result.asArray[target] = asArray[source]
            }
        }
        return result
    }

    var determinant: Double {
        var result: Double = 0.0
        let cofactor = cofactor()
        for j in 0 ..< 3 {
            // the 0 is first row arbitrary. change to any to any other row
            // if you wish.
            let index = 3 * 0 + j  
            result += asArray[index] * cofactor[0, j]
        }
        return result
    }

    func minor() -> Mat3 {
        var result = Mat3()

        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                result[i, j] = cut(row: i, column: j).determinant
            }
        }
        return result
    }

    func cofactor() -> Mat3 {
        var minor = minor()
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                minor[i, j] *= pow(-1.0, Double(i + j))
            }
        }
        
        return minor
    }

    func adjugate() -> Mat3 {
        cofactor().transposed()
    }

    func inverse() -> Mat3 {
        let det = determinant
        guard !absRelFPCompare(det, 0) else {
            return Mat3()
        }
        return adjugate() * (1.0 / det)
    }

    func multiplyVector(_ vec: Vec3) -> Vec3 {
        let x = vec.dot(Vec3(_11, _21, _31))
        let y = vec.dot(Vec3(_12, _22, _32))
        let z = vec.dot(Vec3(_13, _23, _33))

        return Vec3(x, y, z)
    }

    static func rotation(pitch: Double, yaw: Double, roll: Double) -> Mat3 {
        zrotation(roll) * xrotation(pitch) * yrotation(yaw)
    }

    static func xrotation(_ angleDegrees: Double) -> Mat3 {
        let radians = angleDegrees.radians
        return Mat3(1.0, 0.0, 0.0,
                    0.0, cos(radians), sin(radians),
                    0.0, -sin(radians), cos(radians))

    }

    static func yrotation(_ angleDegrees: Double) -> Mat3 {
        let radians = angleDegrees.radians
        return Mat3(cos(radians), 0.0, -sin(radians),
                    0.0, 1.0, 0.0,
                    sin(radians), 0.0, cos(radians))
    }

    static func zrotation(_ angleDegrees: Double) -> Mat3 {
        let radians = angleDegrees.radians
        return Mat3(cos(radians), sin(radians), 0.0,
                    -sin(radians), cos(radians), 0.0,
                    0.0, 0.0, 1.0, 0.0)
    }

    static func axisAngleRotation(_ axis: Vec3, _ angleDegrees: Double) -> Mat3 {
        let radians = angleDegrees.radians

        let c = cos(radians)
        let s = sin(radians)
        let t = 1.0 - c // 1.0 - cos(radians)

        var x = axis.x
        var y = axis.y
        var z = axis.z

        if !absRelFPCompare(axis.magnitudeSquared, 1.0) {
            let scale = 1.0 / axis.magnitude
            x *= scale
            y *= scale
            z *= scale
        }

        return Mat3(t * x * x + c,     t * x * y + s * z,  t * x * z - s * y,
                    t * x * y - s * z, t * y * y + c,      t * y * z + s * x,
                    t * x * z + s * y, t * y * z - s * x,  t * z * z + c)
    }
    
    static func *(lhs: Mat3, rhs: Double) -> Mat3 {
        var result = lhs
        result.asArray = result.asArray.map { $0 * rhs }
        return result
    }

    static func *(lhs: Mat3, rhs: Mat3) -> Mat3 {
        let guts = multiply(matA: lhs.asArray, aRows: 3, aCols: 3,
                            matB: rhs.asArray, bRows: 3, bCols: 3)
        let m = Mat3(guts)
        return m
    }

} // Mat3

struct Mat4: Equatable {
    fileprivate(set) var asArray: [Double]
    var _11: Double {
        asArray[0]
    }
    var _12: Double {
        asArray[1]
    }
    var _13: Double {
        asArray[2]
    }
    var _14: Double {
        asArray[3]
    }
    var _21: Double {
        asArray[4]
    }
    var _22: Double {
        asArray[5]
    }
    var _23: Double {
        asArray[6]
    }
    var _24: Double {
        asArray[7]
    }
    var _31: Double {
        asArray[8]
    }
    var _32: Double {
        asArray[9]
    }
    var _33: Double {
        asArray[10]
    }
    var _34: Double {
        asArray[11]
    }
    var _41: Double {
        asArray[12]
    }
    var _42: Double {
        asArray[13]
    }
    var _43: Double {
        asArray[14]
    }
    var _44: Double {
        asArray[15]
    }

    init() {
        self.asArray = [1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1]
    }
    
    init(_ contents: Double...) {
        var stuff: [Double] = []
        for i in 0 ..< 16 {
            stuff.append(contents[i])
        }
        self.init(stuff)
    }

    init(_ contents: [Double]) {
        self.asArray = contents
    }

    static func translation(x: Double, y: Double, z: Double) -> Mat4 {
        Mat4(1.0, 0.0, 0.0, 0.0,
             0.0, 1.0, 0.0, 0.0, 
             0.0, 0.0, 1.0, 0.0,
             x,   y,   z,   1.0)
    }

    static func translation(_ vec3: Vec3) -> Mat4 {
        Mat4(1.0, 0.0, 0.0, 0.0,
             0.0, 1.0, 0.0, 0.0, 
             0.0, 0.0, 1.0, 0.0,
             vec3.x, vec3.y, vec3.z, 1.0)
        
    }

    func translation() -> Vec3 {
        Vec3(x: _41, y: _42, z: _43)
    }

    func multiplyPoint(_ vec: Vec3) -> Vec3 {
        // hard-codes 1 where the W component would be
        
        let x = vec.x * _11 + vec.y * _21 + vec.z * _31 + 1.0 * _41
        let y = vec.x * _12 + vec.y * _22 + vec.z * _32 + 1.0 * _42
        let z = vec.x * _13 + vec.y * _23 + vec.z * _33 + 1.0 * _43
        
        return Vec3(x, y, z)
    }
    
    func multiplyVector(_ vec: Vec3) -> Vec3 {
        // hard-codes 0 where the W component would be
        
        let x = vec.x * _11 + vec.y * _21 + vec.z * _31 + 0.0 * _41
        let y = vec.x * _12 + vec.y * _22 + vec.z * _32 + 0.0 * _42
        let z = vec.x * _13 + vec.y * _23 + vec.z * _33 + 0.0 * _43
        
        return Vec3(x, y, z)
    }
    
    static func scale(x: Double, y: Double, z: Double) -> Mat4 {
        Mat4(x,   0.0, 0.0, 0.0,
             0.0, y,   0.0, 0.0, 
             0.0, 0.0, z,   0.0,
             0.0, 0.0, 0.0, 1.0)
    }

    static func scale(_ vec3: Vec3) -> Mat4 {
        Mat4(vec3.x, 0.0, 0.0, 0.0,
             0.0, vec3.y, 0.0, 0.0, 
             0.0, 0.0, vec3.z, 0.0,
             0.0, 0.0, 0.0, 1.0)
    }

    func scale() -> Vec3 {
        Vec3(x: _11, y: _22, z: _33)
    }

    static func rotation(pitch: Double, yaw: Double, roll: Double) -> Mat4 {
        zrotation(roll) * xrotation(pitch) * yrotation(yaw)
    }

    static func xrotation(_ angleDegrees: Double) -> Mat4 {
        let radians = angleDegrees.radians
        return Mat4(1.0, 0.0, 0.0, 0.0,
                    0.0, cos(radians), sin(radians), 0.0,
                    0.0, -sin(radians), cos(radians), 0.0,
                    0.0, 0.0, 0.0, 1.0)
    }

    static func yrotation(_ angleDegrees: Double) -> Mat4 {
        let radians = angleDegrees.radians
        return Mat4(cos(radians), 0.0, -sin(radians), 0.0,
                    0.0, 1.0, 0.0, 0.0,
                    sin(radians), 0.0, cos(radians), 0.0,
                    0.0, 0.0, 0.0, 1.0) 
    }

    static func zrotation(_ angleDegrees: Double) -> Mat4 {
        let radians = angleDegrees.radians
        return Mat4(cos(radians), sin(radians), 0.0, 0.0,
                    -sin(radians), cos(radians), 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 1.0) 
    }

    static func axisAngleRotation(_ axis: Vec3, _ angleDegrees: Double) -> Mat4 {
        let radians = angleDegrees.radians

        let c = cos(radians)
        let s = sin(radians)
        let t = 1.0 - c // 1.0 - cos(radians)

        var x = axis.x
        var y = axis.y
        var z = axis.z

        if !absRelFPCompare(axis.magnitudeSquared, 1.0) {
            let scale = 1.0 / axis.magnitude
            x *= scale
            y *= scale
            z *= scale
        }

        return Mat4(t * x * x + c,     t * x * y + s * z,  t * x * z - s * y,  0.0,
                    t * x * y - s * z, t * y * y + c,      t * y * z + s * x,  0.0,
                    t * x * z + s * y, t * y * z - s * x,  t * z * z + c,      0.0,
                    0.0,              0.0,               0.0,               1.0)
    }
    
    /// Call with blah[0, 1] rather than blah[0][1]
    subscript(row: Int, column: Int) -> Double {
        get {
            asArray[row * 4 + column]
        }

        set {
            asArray[row * 4 + column] = newValue
        }
    }

    func transposed() -> Mat4 {
        let srcRows = 4
        let srcCols = 4
        var contents = self.asArray
        for i in 0 ..< srcRows * srcCols {
            let row = i / srcRows
            let col = i % srcRows
            contents[i] = asArray[srcCols * col + row]
        }
        return Mat4(contents)
    }

    func cut(row: Int, column: Int) -> Mat3 {
        var result = Mat3()
        var index = 0

        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                guard i != row && j != column else { continue }
                let target = index
                index += 1  // index++ lolsob
                let source = 4 * i + j
                result.asArray[target] = asArray[source]
            }
        }
        return result
    }

    func minor() -> Mat4 {
        var result = Mat4()
        
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                result[i, j] = cut(row: i, column: j).determinant
            }
        }
        return result
    }

    func cofactor() -> Mat4 {
        var minor = minor()
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                minor[i, j] *= pow(-1.0, Double(i + j))
            }
        }
        return minor
    }

    var determinant: Double {
        var result: Double = 0.0
        let cofactor = cofactor()
        for j in 0 ..< 4 {
            // the 0 is first row arbitrary. change to any to any other row
            // if you wish.
            let index = 4 * 0 + j  
            result += asArray[index] * cofactor[0, j]
        }
        return result
    }

    func adjugate() -> Mat4 {
        cofactor().transposed()
    }

    func inverse() -> Mat4 {
        let det = determinant
        guard !absRelFPCompare(det, 0) else {
            return Mat4()
        }
        return adjugate() * (1.0 / det)
    }

    /// convenience for constructing a transformation matrix with
    /// scale, then rotate, then translate
    static func transform(scale scalev3: Vec3, eulerRotation: Vec3, translate: Vec3) -> Mat4 {
        scale(scalev3)
          * rotation(pitch: eulerRotation.x, yaw: eulerRotation.y, roll: eulerRotation.z)
          * translation(translate)
    }

    /// convenience for constructing a transformation matrix with
    /// scale, then rotate, then translate
    static func transform(scale scalev3: Vec3, rotationAxis: Vec3, rotationDegrees: Double, translate: Vec3) -> Mat4 {
        scale(scalev3)
          * axisAngleRotation(rotationAxis, rotationDegrees)
          * translation(translate)
    }

    static func lookAt(position: Vec3, target: Vec3, up: Vec3) -> Mat4 {
        let forward = (target - position).normalized
        let right = up.cross(forward).normalized
        let newUp = forward.cross(right)

        return Mat4( // Transposed rotation!
          right.x, newUp.x, forward.x, 0.0,
          right.y, newUp.y, forward.z, 0.0,
          right.z, newUp.y, forward.z, 0.0,
          -right.dot(position), -newUp.dot(position), -forward.dot(position), 1.0
        )
    }

    static func *(lhs: Mat4, rhs: Double) -> Mat4 {
        var result = lhs
        result.asArray = result.asArray.map { $0 * rhs }
        return result
    }

    static func *(lhs: Mat4, rhs: Mat4) -> Mat4 {
        let guts = multiply(matA: lhs.asArray, aRows: 4, aCols: 4,
                            matB: rhs.asArray, bRows: 4, bCols: 4)
        let m = Mat4(guts)
        return m
    }
} // Mat4


extension BinaryFloatingPoint {
    /// radiansToDegrees
    var degrees : Self {
        return self * 180 / .pi
    }

    /// degrees to radians
    var radians : Self {
        return self * .pi / 180
    }

}
