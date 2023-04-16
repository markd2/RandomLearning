import XCTest

@testable import MathsFun

final class VectorsTest: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAbsRelFPCompare() {
        XCTAssertTrue(absRelFPCompare(0.0, 0.0))
        XCTAssertTrue(absRelFPCompare(1.0, 1.0))
        XCTAssertTrue(absRelFPCompare(-1.0, -1.0))

        XCTAssertTrue(absRelFPCompare(1.0 / 3.0, 10.0 / 30.0))
        XCTAssertTrue(absRelFPCompare(0.00000000001, 0.00000000001))
        XCTAssertTrue(absRelFPCompare(100000000.0, 100000000.0))
        XCTAssertTrue(absRelFPCompare(-7.699999999999999, -7.7))

        XCTAssertFalse(absRelFPCompare(0.0, 1.0))
        XCTAssertFalse(absRelFPCompare(0.0, -1.0))
        XCTAssertFalse(absRelFPCompare(1.0, 0.0))
        XCTAssertFalse(absRelFPCompare(0.00000000001, 10000000000.0))
        XCTAssertFalse(absRelFPCompare(.greatestFiniteMagnitude, .leastNormalMagnitude))
    }

    func testOutOfTheBoxZero() {
        let v1 = Vec2()
        let expected = Vec2(x: 0.0, y: 0.0)
        XCTAssertEqual(v1, expected)
    }

    func testAdd() {
        let v1 = Vec2(x: 5, y: 10)
        let v2 = Vec2(x: 0.1, y: 0.2)
        let v3 = v1 + v2
        let expected = Vec2(x: 5.1, y: 10.2)

        XCTAssertEqual(v3, expected)
    }

    func testSubtract() {
        let v1 = Vec2(x: 5, y: 0.2)
        let v2 = Vec2(x: 0.1, y: 10.0)
        let v3 = v1 - v2
        let expected = Vec2(x: 4.9, y: -9.8)

        XCTAssertEqual(v3, expected)
    }

    func testMultiply() {
        let v1 = Vec2(x: 5, y: 0.2)
        let v2 = Vec2(x: 0.1, y: 10.0)
        let v3 = v1 * v2
        let expected = Vec2(x: 0.5, y: 2.0)

        XCTAssertEqual(v3, expected)
    }

    func testScalarMultiply() {
        let v1 = Vec2(x: 5, y: 0.2)
        let v3 = v1 * 0.7
        let expected = Vec2(x: 3.5, y: 0.14)

        XCTAssertEqual(v3, expected)
    }

    func testDot() {
        let v1 = Vec2(x: 2.5, y: 11.7)
        let v2 = Vec2(x: -5.0, y: 0.25)
        let expected = -9.575
        XCTAssertEqual(v1.dot(v2), expected)
    }

    func testMagnitude() {
        let v1 = Vec2(x: 2.0, y: 4.0)
        let expected1 = 4.47213595499958
        XCTAssertEqual(v1.magnitude, expected1)

        let v2 = Vec2(x: 1.0, y: 0.0)
        let expected2 = 1.0
        XCTAssertEqual(v2.magnitude, expected2)

        let v3 = Vec2(x: 0.0, y: 1.0)
        let expected3 = 1.0
        XCTAssertEqual(v3.magnitude, expected3)
    }

    func testMagnitudeSquared() {
        let v1 = Vec2(x: 2.0, y: 4.0)
        let expected1 = 20.0
        XCTAssertEqual(v1.magnitudeSquared, expected1)

        let v2 = Vec2(x: 1.0, y: 0.0)
        let expected2 = 1.0
        XCTAssertEqual(v2.magnitudeSquared, expected2)
    }

    func testDistance() {
        let v1 = Vec2(x: 1.0, y: 2.0)
        let v2 = Vec2(x: 5.5, y: -2.5)
        let expected = 6.363961030678928
        XCTAssertEqual(distance(v1, v2), expected)
    }

    // --------------------------------------------------
    // Vec3D

    func testOutOfTheBoxZero3() {
        let v1 = Vec3()
        let expected = Vec3(x: 0.0, y: 0.0, z: 0.0)
        XCTAssertEqual(v1, expected)
    }

    func testAdd3() {
        let v1 = Vec3(x: 5, y: 10, z: -20.0)
        let v2 = Vec3(x: 0.1, y: 0.2, z: 8.0)
        let v3 = v1 + v2
        let expected = Vec3(x: 5.1, y: 10.2, z: -12.0)

        XCTAssertEqual(v3, expected)
    }

    func testSubtract3() {
        let v1 = Vec3(x: 5, y: 0.2, z: -20.0)
        let v2 = Vec3(x: 0.1, y: 10.0, z: 8.2)
        let v3 = v1 - v2
        let expected = Vec3(x: 4.9, y: -9.8, z: -28.2)

        XCTAssertEqual(v3, expected)
    }

    func testMultiply3() {
        let v1 = Vec3(x: 5, y: 0.2, z: 8.0)
        let v2 = Vec3(x: 0.1, y: 10.0, z: -1.2)
        let v3 = v1 * v2
        let expected = Vec3(x: 0.5, y: 2.0, z: -9.6)

        XCTAssertEqual(v3, expected)
    }

    func testScalarMultiply3() {
        let v1 = Vec3(x: 5, y: 0.2, z: -11.0)
        let v3 = v1 * 0.7
        let expected = Vec3(x: 3.5, y: 0.14, z: -7.7)

        XCTAssertEqual(v3, expected)
    }

    func testDot3() {
        let v1 = Vec3(x: 2.5, y: 11.7, z: -2.0)
        let v2 = Vec3(x: -5.0, y: 0.25, z: 3.5)
        let expected = -16.575
        XCTAssertEqual(v1.dot(v2), expected)
    }

    func testMagnitude3() {
        let v1 = Vec3(x: 2.0, y: 4.0, z: -5.5)
        let expected1 = 7.088723439378913
        XCTAssertEqual(v1.magnitude, expected1)

        let v2 = Vec3(x: 1.0, y: 0.0, z: 0.0)
        let expected2 = 1.0
        XCTAssertEqual(v2.magnitude, expected2)

        let v3 = Vec3(x: 0.0, y: 0.0, z: 1.0)
        let expected3 = 1.0
        XCTAssertEqual(v3.magnitude, expected3)
    }

    func testMagnitudeSquared3() {
        let v1 = Vec3(x: 2.0, y: 4.0, z: -5.5)
        let expected1 = 50.25
        XCTAssertEqual(v1.magnitudeSquared, expected1)

        let v2 = Vec3(x: 0.0, y: 0.0, z: 1.0)
        let expected2 = 1.0
        XCTAssertEqual(v2.magnitudeSquared, expected2)
    }
    
    func testDistance3() {
        let v1 = Vec3(x: 1.0, y: 2.0, z: 3.0)
        let v2 = Vec3(x: 5.5, y: -2.5, z: 3.5)
        let expected = 6.383572667401852
        XCTAssertEqual(distance(v1, v2), expected)
    }

}
