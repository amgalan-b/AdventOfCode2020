import Babbage
import XCTest

extension Y2020 {

    enum D9 {

        static func part1() -> Int {
            return File.readLines(file: "2020-9.txt")
                .map { Int($0)! }
                ._firstInvalid(length: 25)!
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-9.txt")
                .map { Int($0)! }
                .subsequences()
                .first { $0.sum() == 1721308972 }!
                .run { $0.min()! + $0.max()! }
        }
    }
}

extension Array where Element == Int {

    fileprivate func _firstInvalid(length: Int) -> Int? {
        for i in length ..< count {
            let buffer = self[i - length ..< i]
            let set = Set(buffer)

            let isValid = buffer.map { set.contains(self[i] - $0) }
                .reduce(false) { $0 || $1 }

            if isValid {
                continue
            }

            return self[i]
        }

        return nil
    }
}

final class Y2020_D9_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D9.part1(), 1721308972)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D9.part2(), 209694133)
    }

    func testExample() {
        let result = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
            ._firstInvalid(length: 5)

        XCTAssertEqual(result, 127)
    }

    func testExample2() {
        let result = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
            .firstSubsequence { $0.sum() == 127 }!
            .run { $0.min()! + $0.max()! }

        XCTAssertEqual(result, 62)
    }
}
