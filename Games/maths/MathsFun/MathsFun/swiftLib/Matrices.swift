import Foundation

struct Mat2: Equatable {
    let asArray: [Double]
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
        self.asArray = [0, 0,
                        0, 0]
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
}


struct Mat3 {
    let asArray: [Double]
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

    init() {
        self.asArray = [0, 0, 0, 
                        0, 0, 0, 
                        0, 0, 0]
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
}

struct Mat4 {
    let asArray: [Double]
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
        self.asArray = [0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0]
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
}


