import Babbage
import XCTest

extension Y2020 {

    enum D2 {

        static func part1() -> Int {
            return File.readLines(file: "2020-2.txt")
                .count { $0._isValid() }
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-2.txt")
                .count { $0._isOtherValid() }
        }
    }
}

extension String {

    fileprivate func _isValid() -> Bool {
        let (min, max, character, word) = _parse()

        return word.count(of: character)
            .run { (min ... max).contains($0) }
    }

    fileprivate func _isOtherValid() -> Bool {
        let (x, y, character, word) = _parse()
        return (word[x - 1] == character) ^ (word[y - 1] == character)
    }

    fileprivate func _parse() -> (Int, Int, Character, String) {
        let matches = regexMatches(regex: "(\\d+)-(\\d+) ([a-z]): ([a-z]+)")
            .first!
            .captureGroups

        return (Int(matches[0])!, Int(matches[1])!, Character(matches[2]), matches[3])
    }
}

final class Y2020_D2_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D2.part1(), 422)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D2.part2(), 451)
    }
}
