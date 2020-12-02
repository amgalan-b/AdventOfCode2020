import Babbage
import XCTest

extension Y2020 {

    enum D1 {

        static func part1() -> Int {
            return File.readLines(file: "2020-1.txt")
                .map { Int($0)! }
                .combinations(ofCount: 2)
                .first { $0.sum() == 2020 }!
                .product()
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-1.txt")
                .map { Int($0)! }
                .combinations(ofCount: 3)
                .first { $0.sum() == 2020 }!
                .product()
        }
    }
}

final class Y2020_D1_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D1.part1(), 997899)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D1.part2(), 131248694)
    }
}
