import Foundation

private func multiply(matA: [Double], aRows: Int, aCols: Int,
                      matB: [Double], bRows: Int, bCols: Int) -> [Double] {
    if (aCols != bRows) { return [] }
    
    var out = [Double](repeating: 0.0, count: aRows * bCols)
    for i in 0 ..< aRows {
        for j in 0 ..< bCols {
            out[bCols * i + j] = 0.0;
            for k in 0 ..< bRows {
                let a = aCols * i + k;
                let b = bCols * k + j;
                out[bCols * i + j] += matA[a] * matB[b];
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

