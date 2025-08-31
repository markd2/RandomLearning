import XCTest

@testable import MathsFun

final class Geometry2DTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testTypedef() {
        let p1 = Point2D(x: 1, y: 3)
        let p2 = Point2D(x: 7, y: -3)
        XCTAssertEqual((p1 - p2).magnitude, 8.48528137423857)
    }
}
