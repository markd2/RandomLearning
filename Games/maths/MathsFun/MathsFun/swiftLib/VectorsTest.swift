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

}
