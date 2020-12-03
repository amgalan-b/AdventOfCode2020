import Babbage
import XCTest

extension Y2020 {

    enum D3 {

        static func part1() -> Int {
            return File.readLines(file: "2020-3.txt")
                .map { Array($0) }
                ._countTrees(right: 3, down: 1)
        }

        static func part2() -> Int {
            let input = File.readLines(file: "2020-3.txt")
                .map { Array($0) }

            return [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
                .map { input._countTrees(right: $0.0, down: $0.1) }
                .product()
        }
    }
}

extension Array where Element == Array<Character> {

    fileprivate func _countTrees(right: Int, down: Int) -> Int {
        let width = self[0].count

        var x = right
        var y = down
        var total = 0

        while y < count {
            let character = self[y][x % width]
            if character == "#" {
                total += 1
            }

            x += right
            y += down
        }

        return total
    }
}

final class Y2020_D3_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D3.part1(), 225)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D3.part2(), 1115775000)
    }
}
