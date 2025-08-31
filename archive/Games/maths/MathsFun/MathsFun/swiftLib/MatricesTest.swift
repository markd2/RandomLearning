import XCTest

@testable import MathsFun

final class MatricesTest: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMat2Construction() throws {
        let m = Mat2()
        XCTAssertEqual(m._11, 1)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m[2-1, 1-1], 0)
        XCTAssertEqual(m[2-1, 2-1], 1)
        XCTAssertEqual(m.asArray, [1, 0, 
                                   0, 1])

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
        XCTAssertEqual(m._11, 1)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m._13, 0)
        XCTAssertEqual(m[2-1, 1-1], 0)
        XCTAssertEqual(m[2-1, 2-1], 1)
        XCTAssertEqual(m[2-1, 3-1], 0)
        XCTAssertEqual(m._31, 0)
        XCTAssertEqual(m._32, 0)
        XCTAssertEqual(m._33, 1)
        XCTAssertEqual(m.asArray, [1, 0, 0,
                                   0, 1, 0,
                                   0, 0, 1])


        let m2 = Mat3(1, 2, 3,
                      4, 5, 6,
                      7, 8, 9)
        XCTAssertEqual(m2._11, 1)
        XCTAssertEqual(m2._12, 2)
        XCTAssertEqual(m2._13, 3)
        XCTAssertEqual(m2._21, 4)
        XCTAssertEqual(m2._22, 5)
        XCTAssertEqual(m2._23, 6)
        XCTAssertEqual(m2[3-1, 1-1], 7)
        XCTAssertEqual(m2[3-1, 2-1], 8)
        XCTAssertEqual(m2[3-1, 3-1], 9)
        XCTAssertEqual(m2.asArray, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    }

    func testMat4Construction() throws {
        let m = Mat4()
        XCTAssertEqual(m._11, 1)
        XCTAssertEqual(m._12, 0)
        XCTAssertEqual(m._13, 0)
        XCTAssertEqual(m._14, 0)
        XCTAssertEqual(m._21, 0)
        XCTAssertEqual(m._22, 1)
        XCTAssertEqual(m._23, 0)
        XCTAssertEqual(m._24, 0)
        XCTAssertEqual(m._31, 0)
        XCTAssertEqual(m._32, 0)
        XCTAssertEqual(m[3-1, 3-1], 1)
        XCTAssertEqual(m[3-1, 4-1], 0)
        XCTAssertEqual(m[4-1, 1-1], 0)
        XCTAssertEqual(m[4-1, 2-1], 0)
        XCTAssertEqual(m._43, 0)
        XCTAssertEqual(m._44, 1)
        XCTAssertEqual(m.asArray, [1, 0, 0, 0, 
                                   0, 1, 0, 0,
                                   0, 0, 1, 0,
                                   0, 0, 0, 1])
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

    func testMat3Subscripting() {
        let m = Mat3(1, 2, 3,
                     4, 5, 6,
                     7, 8, 9)
        XCTAssertEqual(m[1, 0], 4)
    }

    // ----------

    func testMat2Transpose() {
        let m = Mat2(1, 2, 3, 4)
        let t = m.transposed()

        XCTAssertEqual(t._11, 1)
        XCTAssertEqual(t._12, 3)
        XCTAssertEqual(t._21, 2)
        XCTAssertEqual(t._22, 4)
    }

    func testMat3Transpose() {
        let m = Mat3(1, 2, 3,
                     4, 5, 6,
                     7, 8, 9)
        let expected: [Double] = [1, 4, 7,
                                  2, 5, 8,
                                  3, 6, 9]
        let t = m.transposed()
        XCTAssertEqual(t.asArray, expected)
    }

    func testMat4Transpose() {
        let m = Mat4(1, 2, 3, 4,
                     5, 6, 7, 8,
                     9, 10, 11, 12,
                     13, 14, 15, 16)
        let expected: [Double] = [1, 5, 9, 13,
                                  2, 6, 10, 14, 
                                  3, 7, 11, 15,
                                  4, 8, 12, 16]
        let t = m.transposed()
        XCTAssertEqual(t.asArray, expected)
    }

    // ----------

    func testMat2ScalarMultiplication() {
        let m = Mat2(2, 4, 8, 16)
        let s = m * 0.5
        let expected: [Double] = [1, 2, 4, 8]
        XCTAssertEqual(s.asArray, expected)
    }

    func testMat3ScalarMultiplication() {
        let m = Mat3(4, 8, 12,
                     16, 20, 24,
                     28, 32, 36)
        let s = m * 0.25
        let expected: [Double] = [1, 2, 3,
                                  4, 5, 6,
                                  7, 8, 9]
        XCTAssertEqual(s.asArray, expected)
    }

    func testMat4ScalarMultiplication() {
        let m = Mat4(2, 4, 6, 8,
                     10, 12, 14, 16,
                     18, 20, 22, 24,
                     26, 28, 30, 32) 
        let s = m * 0.5
        let expected: [Double] = [1, 2, 3, 4,
                                  5, 6, 7, 8,
                                  9, 10, 11, 12,
                                  13, 14, 15, 16]
        XCTAssertEqual(s.asArray, expected)
    }

    // ----------
    func testMat2Multiplication() {
        let m1 = Mat2(1, 2, 3, 4)
        let m2 = Mat2(5, 6, 7, 8)
        let expected: [Double] = [19, 22,
                                  43, 50]
        let p = m1 * m2
        XCTAssertEqual(p.asArray, expected)
    }

    func testMat3Multiplication() {
        let m1 = Mat3(1, 2, 3,
                      4, 5, 6,
                      7, 8, 9)
        let m2 = Mat3(10, 11, 12,
                      13, 14, 15,
                      16, 17, 18)
        let expected: [Double] = [84, 90, 96,
                                  201, 216, 231,
                                  318, 342, 366]
                                  
        let p = m1 * m2
        XCTAssertEqual(p.asArray, expected)
    }

    func testMat4Multiplication() {
        let m1 = Mat4(1, 2, 3, 4,
                      5, 6, 7, 8,
                      9, 10, 11, 12,
                      13, 14, 15, 16)
        let m2 = Mat4(17, 18, 19, 20,
                      21, 22, 23, 24,
                      25, 26, 27, 28,
                      29, 30, 31, 32)
        let expected: [Double] = [250, 260, 270, 280,
                                  618, 644, 670, 696,
                                  986, 1028, 1070, 1112,
                                  1354, 1412, 1470, 1528]
                                  
        let p = m1 * m2
        XCTAssertEqual(p.asArray, expected)
    }

    // ----------
    
    func testMat2Determinant() {
        let m = Mat2(1, 2, 3, 4)
        let d = m.determinant
        XCTAssertEqual(d, -2)
    }

    // ----------
    
    func testMat3Cut() {
        let m = Mat3(1, 2, 3,
                     4, 5, 6,
                     7, 8, 9)

        let c1 = m.cut(row: 0, column: 0)
        let expected1: [Double] = [5, 6,
                                   8, 9]
        XCTAssertEqual(c1.asArray, expected1)

        let c2 = m.cut(row: 1, column: 1)
        let expected2: [Double] = [1, 3,
                                   7, 9]
        XCTAssertEqual(c2.asArray, expected2)

        let c3 = m.cut(row: 2, column: 0)
        let expected3: [Double] = [2, 3,
                                   5, 6]
        XCTAssertEqual(c3.asArray, expected3)
    }

    func testMat4Cut() {
        let m = Mat4(1, 2, 3, 4,
                     5, 6, 7, 8,
                     9, 10, 11, 12,
                     13, 14, 15, 16)

        let c1 = m.cut(row: 0, column: 0)
        let expected1: [Double] = [6, 7, 8,
                                   10, 11, 12,
                                   14, 15, 16]
        XCTAssertEqual(c1.asArray, expected1)

        let c2 = m.cut(row: 1, column: 1)
        let expected2: [Double] = [1, 3, 4,
                                   9, 11, 12,
                                   13, 15, 16]
        XCTAssertEqual(c2.asArray, expected2)

        let c3 = m.cut(row: 2, column: 3)
        let expected3: [Double] = [1, 2, 3,
                                   5, 6, 7,
                                   13, 14, 15]
        XCTAssertEqual(c3.asArray, expected3)
    }

    func testMat2Minor() {
        let maj = Mat2(1, 2,
                       3, 4)
        let expected: [Double] = [4, 3,
                                  2, 1]
        let min = maj.minor()
        XCTAssertEqual(min.asArray, expected)
    }

    func testMat2Cofactor() {
        let maj = Mat2(1, 2,
                       3, 4)
        let expected: [Double] = [4, -3,
                                  -2, 1]
        let cof = maj.cofactor()
        XCTAssertEqual(cof.asArray, expected)
    }

    func testMat3Minor() {
        let maj = Mat3(1, 2, 3,
                       4, 5, 6,
                       7, 8, 9)
        let expected: [Double] = [-3, -6, -3,
                                  -6, -12, -6,
                                  -3, -6, -3]
        let min = maj.minor()
        XCTAssertEqual(min.asArray, expected)
    }

    func testMat3Cofactor() {
        let maj = Mat3(1, 2, 3,
                       4, 5, 6,
                       7, 8, 9)
        let expected: [Double] = [-3, 6, -3,
                                  6, -12, 6,
                                  -3, 6, -3]
        let min = maj.cofactor()
        XCTAssertEqual(min.asArray, expected)
    }

    func testMat4Minor() {
        // the usual ascending numbers matrix is non-invertable, so all
        // of the 3x3 determinants will be zero, leading to uninteresting
        // tests
        let maj = Mat4(1, 4, 2, 3,
                       0, 1, 4, 4,
                       -1, 0, 1, 0,
                       2, 0, 4, 1)

        let expected: [Double] = [1.0, -20.0, 1.0, 6.0,
                                  4.0, -15.0, 4.0, 24.0,
                                  -38.0, -20.0, 27.0, 32.0,
                                  -13.0, 0.0, -13.0, -13.0]

        let min = maj.minor()
        XCTAssertEqual(min.asArray, expected)
    }

    func testMat4Cofactor() {
        let maj = Mat4(1, 4, 2, 3,
                       0, 1, 4, 4,
                       -1, 0, 1, 0,
                       2, 0, 4, 1)
        let expected: [Double] = [1.0, 20.0, 1.0, -6.0,
                                  -4.0, -15.0, -4.0, 24.0,
                                  -38.0, 20.0, 27.0, -32.0,
                                  13.0, 0.0, 13.0, -13.0]
        let cof = maj.cofactor()
        XCTAssertEqual(cof.asArray, expected)
    }

    func testMat3Determinant() {
        let m = Mat3(1, 2, 3,
                     4, 5, 6,
                     7, 8, 9)
        let determinant = m.determinant
        XCTAssertEqual(determinant, 0)
    }

    func testMat4Determinant() {
        let m1 = Mat4(1, 2, 3, 4,
                      5, 6, 7, 8,
                      9, 10, 11, 12,
                      13, 14, 15, 16)
        let d1 = m1.determinant
        XCTAssertEqual(d1, 0)

        let m2 = Mat4(4, 3, 2, 2,
                      0, 1, -3, 3,
                      0, -1, 3, 3,
                      0, 3, 1, 1)
        let d2 = m2.determinant
        XCTAssertEqual(d2, -240)
    }

    func testMat2Adjugate() {
        let m = Mat2(1, 2,
                     3, 4)
        let expected: [Double] = [4, -2,
                                  -3, 1]
        XCTAssertEqual(m.adjugate().asArray, expected)
    }

    func testMat3Adjugate() {
        let m = Mat3(3, 4, 1,
                     0, 2, 10,
                     1, 3, 5)
        let expected: [Double] = [-20.0, -17.0, 38.0,
                                  10.0, 14.0, -30.0,
                                  -2.0, -5.0, 6.0]
        XCTAssertEqual(m.adjugate().asArray, expected)
    }

    func testMat4Adjugate() {
        let m = Mat4(1, 4, 2, 3,
                     0, 1, 4, 4,
                     -1, 0, 1, 0,
                     2, 0, 4, 1)
        let expected: [Double] = [1.0, -4.0, -38.0, 13.0, 
                                  20.0, -15.0, 20.0, 0.0, 
                                  1.0, -4.0, 27.0, 13.0, 
                                  -6.0, 24.0, -32.0, -13.0]
        XCTAssertEqual(m.adjugate().asArray, expected)
    }

    func testMat2Inverse() {
        let m = Mat2(1, 2,
                     3, 4)
        let expected: [Double] = [-2.0, 1.0,
                                  1.5, -0.5]
        let inverse = m.inverse()
        XCTAssertEqual(inverse.asArray, expected)

        // and make sure the inverse makes the identity when multiplied
        let identity = Mat2()
        XCTAssertEqual(m * inverse, identity)
    }

    func testMat3Inverse() {
        let m = Mat3(3, 4, 1,
                     0, 2, 10,
                     1, 3, 5)
        let expected: [Double] = [0.909, 0.773, -1.728,
                                  -0.455, -0.636, 1.364, 
                                  0.091, 0.227, -0.273]

        let inverse = m.inverse()
        for (a, b) in zip(inverse.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.001)
        }

        // and make sure the inverse makes the identity when multiplied
        let identity = Mat3()
        let i2 = m * inverse

        for (a, b) in zip(i2.asArray, identity.asArray) {
            XCTAssertEqual(a, b, accuracy: 0.001)
        }
    }

    func testMat4Inverse() {
        let m = Mat4(1, 4, 2, 3,
                     0, 1, 4, 4,
                     -1, 0, 1, 0,
                     2, 0, 4, 1)
        let expected: [Double] = [0.015, -0.062, -0.585, 0.2, 
                                  0.308, -0.231, 0.308, 0.0,
                                  0.0154, -0.062, 0.415, 0.2,
                                  -0.092, 0.369, -0.492, -0.2]
        let inverse = m.inverse()
        for (a, b) in zip(inverse.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.001)
        }

        // and make sure the inverse makes the identity when multiplied
        let identity = Mat4()
        let i2 = m * inverse

        for (a, b) in zip(i2.asArray, identity.asArray) {
            XCTAssertEqual(a, b, accuracy: 0.001)
        }
    }

    func testMat4Translation() {
        let t1 = Mat4.translation(x: 2, y: 3, z: 4)
        let v1 = t1.translation()
        let expected = Vec3(x: 2, y: 3, z: 4)
        XCTAssertEqual(v1, expected)

        let t2 = Mat4.translation(expected)
        XCTAssertEqual(t2.translation(), expected)
    }

    func testMat4Scale() {
        let t1 = Mat4.scale(x: 2, y: 3, z: 4)
        let v1 = t1.scale()
        let expected = Vec3(x: 2, y: 3, z: 4)
        XCTAssertEqual(v1, expected)

        let t2 = Mat4.scale(expected)
        XCTAssertEqual(t2.scale(), expected)
    }
    
    func testMat3Rotate() {
        let expected: [Double] = [1, 2, 3,
                                  4, 5, 6,
                                  7, 8, 9]
        let m = Mat3(expected)
        // rotating twice in the same direction should end up at the original place
        let r1 = Mat3.rotation(pitch: 180, yaw: 180, roll: 180)
        let m2 = r1 * m
        let m3 = r1 * m2

        // Well, modulo floating point error
        for (a, b) in zip(m3.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.00001)
        }
    }

    func testMat4Rotate() {
        let expected: [Double] = [1, 2, 3, 4,
                                  5, 6, 7, 8,
                                  9, 10, 11, 12,
                                  13, 14, 15, 16]
        let m = Mat4(expected)
        // rotating twice in the same direction should end up at the original place
        let r1 = Mat4.rotation(pitch: 180, yaw: 180, roll: 180)
        let m2 = r1 * m
        let m3 = r1 * m2

        // Well, modulo floating point error
        for (a, b) in zip(m3.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.00001)
        }
    }

    func testMat3AxisAngleRotate() {
        let expected: [Double] = [1, 2, 3,
                                  4, 5, 6,
                                  7, 8, 9]
        let m = Mat3(expected)
        let axis = Vec3(1, 1, 1)

        // rotating twice in the same direction should end up at the original place
        let r1 = Mat3.axisAngleRotation(axis, 180)
        let m2 = r1 * m
        let m3 = r1 * m2

        // Well, modulo floating point error
        for (a, b) in zip(m3.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.00001)
        }
    }

    func testMat4AxisAngleRotate() {
        let expected: [Double] = [1, 2, 3, 4,
                                  5, 6, 7, 8,
                                  9, 10, 11, 12,
                                  13, 14, 15, 16]
        let m = Mat4(expected)
        let axis = Vec3(1, 1, 1)

        // rotating twice in the same direction should end up at the original place
        let r1 = Mat4.axisAngleRotation(axis, 180)
        let m2 = r1 * m
        let m3 = r1 * m2

        // Well, modulo floating point error
        for (a, b) in zip(m3.asArray, expected) {
            XCTAssertEqual(a, b, accuracy: 0.00001)
        }
    }

    func testMat4MultiplyPoint() {
        let m = Mat4(1, 2, 3, 4,
                     5, 6, 7, 8,
                     9, 10, 11, 12,
                     13, 14, 15, 16)
        let p = Vec3(1, 2, 3)
        let p1 = m.multiplyPoint(p)

        let expected: [Double] = [51, 58, 65]
        XCTAssertEqual(p1.asArray, expected)
    }

    func testMat4MultiplyVector() {
        let m = Mat4(1, 2, 3, 4,
                     5, 6, 7, 8,
                     9, 10, 11, 12,
                     13, 14, 15, 16)
        let p = Vec3(1, 2, 3)
        let p1 = m.multiplyVector(p)

        let expected: [Double] = [38, 44, 50]
        XCTAssertEqual(p1.asArray, expected)
    }

    func testMat3MultiplyVector() {
        let m = Mat3(1, 2, 3,
                     4, 5, 6,
                     7, 8, 9)
        let p = Vec3(1, 2, 3)
        let p1 = m.multiplyVector(p)

        let expected: [Double] = [30, 36, 42]
        XCTAssertEqual(p1.asArray, expected)
    }

    func testMat4TransformConveniences() {
        let scale = Vec3(1, 2, 3)
        let rotation = Vec3(60, 120, 180)
        let translation = Vec3(3, 2, 1)
        let transform = Mat4.transform(scale: scale, eulerRotation: rotation, translate: translation)
        
        let point = Vec3(10, 20, 30)
        let transformedPoint = transform.multiplyPoint(point)
        // totally cheating on this one...
        let expected: [Double] = [16.971143170299754, -95.94228634059948, 4.480762113533167]
        XCTAssertEqual(transformedPoint.asArray, expected)
    }

}
