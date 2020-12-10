import Babbage
import SwiftGraph
import XCTest

extension Y2020 {

    enum D10 {

        static func part1() -> Int {
            return File.readLines(file: "2020-10.txt")
                .map { Int($0)! }
                .sorted()
                .paired()
                .map { $0.right - $0.left }
                .apply {
                    $0.insert(1, at: 0)
                    $0.append(3)
                }
                .run { $0.count(of: 3) * $0.count(of: 1) }
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-10.txt")
                .map { Int($0)! }
                .sorted()
                ._arrangements()
        }
    }
}

extension Array where Element == Int {

    fileprivate func _arrangements() -> Int {
        var arrangementsByElement = DefaultDictionary<Int, Int>(defaultValue: 0)
        arrangementsByElement[0] = 1

        for element in self {
            for number in (element - 3) ... (element - 1) {
                arrangementsByElement[element] += arrangementsByElement[number]
            }
        }

        return arrangementsByElement[last!]
    }
}

final class Y2020_D10_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D10.part1(), 2738)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D10.part2(), 74049191673856)
    }

    func testExample() {
        let result = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
            .sorted()
            ._arrangements()

        XCTAssertEqual(result, 8)
    }

    func testExample2() {
        let result = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
            .sorted()
            ._arrangements()

        XCTAssertEqual(result, 19208)
    }
}
