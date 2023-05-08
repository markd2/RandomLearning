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
    
    func minor() -> Mat2 {
        Mat2(_22, _21, _12, _11)
    }
} // Mat2


struct Mat3 {
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

    func minor() -> Mat3 {
        var result = Mat3()

        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                result[i, j] = cut(row: i, column: j).determinant
            }
        }
        return result
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
}

struct Mat4 {
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
}


