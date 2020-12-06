import Babbage
import XCTest

extension Y2020 {

    enum D6 {

        static func part1() -> Int {
            return _parseInput()
                .map { $0.joined() }
                .map { Set($0) }
                .map { $0.count }
                .sum()
        }

        static func part2() -> Int {
            return _parseInput()
                .map { $0._commonCharacters() }
                .map { $0.count }
                .sum()
        }

        private static func _parseInput() -> [[String]] {
            return File.read(file: "2020-6.txt")
                .components(separatedBy: .newlines)
                .split(separator: "")
                .map { Array($0) }
        }
    }
}

extension Array where Element == String {

    fileprivate func _commonCharacters() -> Set<Character> {
        return map { Set($0) }
            .reduce1 { $0.intersection($1) }!
    }
}

final class Y2020_D6_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D6.part1(), 6273)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D6.part2(), 3254)
    }
}
