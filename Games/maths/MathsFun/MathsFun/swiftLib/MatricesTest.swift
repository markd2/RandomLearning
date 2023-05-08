import XCTest

@testable import MathsFun

final class MatricesTest: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMat2Construction() throws {
        let m = Mat2()
        XCTAssertEqual(m._11, 0)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m._21, 0)
        XCTAssertEqual(m._22, 0)
        XCTAssertEqual(m.asArray, [0, 0, 0, 0])

        let m2 = Mat2(1, 2, 3, 4)
        XCTAssertEqual(m2._11, 1)
        XCTAssertEqual(m2._12, 2)
        XCTAssertEqual(m2._21, 3)
        XCTAssertEqual(m2._22, 4)
        XCTAssertEqual(m2.asArray, [1, 2, 3, 4])

        let contents: [Double] = [5, 6, 7, 8]
        let m3 = Mat2(contents)
        XCTAssertEqual(m3.asArray, contents)
    }

    func testMat3Construction() throws {
        let m = Mat3()
        XCTAssertEqual(m._11, 0)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m._13, 0)
        XCTAssertEqual(m._21, 0)
        XCTAssertEqual(m._22, 0)
        XCTAssertEqual(m._23, 0)
        XCTAssertEqual(m._31, 0)
        XCTAssertEqual(m._32, 0)
        XCTAssertEqual(m._33, 0)
        XCTAssertEqual(m.asArray, [0, 0, 0, 0, 0, 0, 0, 0, 0])


        let m2 = Mat3(1, 2, 3,
                      4, 5, 6,
                      7, 8, 9)
        XCTAssertEqual(m2._11, 1)
        XCTAssertEqual(m2._12, 2)
        XCTAssertEqual(m2._13, 3)
        XCTAssertEqual(m2._21, 4)
        XCTAssertEqual(m2._22, 5)
        XCTAssertEqual(m2._23, 6)
        XCTAssertEqual(m2._31, 7)
        XCTAssertEqual(m2._32, 8)
        XCTAssertEqual(m2._33, 9)
        XCTAssertEqual(m2.asArray, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    }

    func testMat4Construction() throws {
        let m = Mat4()
        XCTAssertEqual(m._11, 0)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m._13, 0)
        XCTAssertEqual(m._14, 0)
        XCTAssertEqual(m._21, 0)
        XCTAssertEqual(m._22, 0)
        XCTAssertEqual(m._23, 0)
        XCTAssertEqual(m._24, 0)
        XCTAssertEqual(m._31, 0)
        XCTAssertEqual(m._32, 0)
        XCTAssertEqual(m._33, 0)
        XCTAssertEqual(m._34, 0)
        XCTAssertEqual(m._41, 0)
        XCTAssertEqual(m._42, 0)
        XCTAssertEqual(m._43, 0)
        XCTAssertEqual(m._44, 0)
        XCTAssertEqual(m.asArray, [0, 0, 0, 0, 
                                   0, 0, 0, 0,
                                   0, 0, 0, 0,
                                   0, 0, 0, 0])
        let m2 = Mat4(1, 2, 3, 4,
                      5, 6, 7, 8,
                      9, 10, 11, 12,
                      13, 14, 15, 16)
        XCTAssertEqual(m2._11, 1)
        XCTAssertEqual(m2._12, 2)
        XCTAssertEqual(m2._13, 3)
        XCTAssertEqual(m2._14, 4)
        XCTAssertEqual(m2._21, 5)
        XCTAssertEqual(m2._22, 6)
        XCTAssertEqual(m2._23, 7)
        XCTAssertEqual(m2._24, 8)
        XCTAssertEqual(m2._31, 9)
        XCTAssertEqual(m2._32, 10)
        XCTAssertEqual(m2._33, 11)
        XCTAssertEqual(m2._34, 12)
        XCTAssertEqual(m2._41, 13)
        XCTAssertEqual(m2._42, 14)
        XCTAssertEqual(m2._43, 15)
        XCTAssertEqual(m2._44, 16)
        XCTAssertEqual(m2.asArray, [1, 2, 3, 4,
                                    5, 6, 7, 8, 
                                    9, 10, 11, 12,
                                    13, 14, 15, 16])
    }

    func testMat2Transpose() {
        let m = Mat2(1, 2, 3, 4)
        let t = m.transposed()

        XCTAssertEqual(t._11, 1)
        XCTAssertEqual(t._12, 3)
        XCTAssertEqual(t._21, 2)
        XCTAssertEqual(t._22, 4)
    }
}
