import Babbage
import XCTest

extension Y2020 {

    enum D4 {

        static func part1() -> Int {
            return _parseInput()
                .filter { $0._containsRequiredFields() }
                .count
        }

        static func part2() -> Int {
            return _parseInput()
                .filter { $0._containsRequiredFields() }
                .filter { $0._containsValidValues() }
                .count
        }

        private static func _parseInput() -> [[String: String]] {
            return File.read(file: "2020-4.txt")
                .components(separatedBy: .newlines)
                .split(separator: "")
                .map { $0.joined(separator: " ") }
                .map { $0._parseDictionary() }
        }
    }
}

extension Dictionary where Key == String, Value == String {

    fileprivate func _containsRequiredFields() -> Bool {
        return Set(keys)
            .apply { $0.remove("cid") }
            .count == 7
    }

    fileprivate func _containsValidValues() -> Bool {
        return self["byr"]!._validYear(in: 1920 ... 2002) &&
            self["iyr"]!._validYear(in: 2010 ... 2020) &&
            self["eyr"]!._validYear(in: 2020 ... 2030) &&
            self["hgt"]!._validHeight() &&
            self["hcl"]!._matches(regex: "^#[0-9a-f]{6}$") &&
            self["ecl"]!._matches(regex: "^(amb|blu|brn|gry|grn|hzl|oth)$") &&
            self["pid"]!._matches(regex: "^[0-9]{9}$")
    }
}

extension String {

    fileprivate func _parseDictionary() -> [String: String] {
        return components(separatedBy: " ")
            .map { $0.components(separatedBy: ":") }
            .map { ($0[0], $0[1]) }
            .run { [String: String](uniqueKeysWithValues: $0) }
    }

    fileprivate func _validYear(in range: ClosedRange<Int>) -> Bool {
        return run { Int($0)! }
            .run { $0.digits.count == 4 && range.contains($0) }
    }

    fileprivate func _validHeight() -> Bool {
        guard let groups = regexMatches(regex: "([0-9]+)(in|cm)").first?.captureGroups else {
            return false
        }

        let amount = Int(groups[0])!
        let unit = groups[1]

        switch unit {
        case "cm":
            return (150 ... 193).contains(amount)
        case "in":
            return (59 ... 76).contains(amount)
        default:
            return false
        }
    }

    fileprivate func _matches(regex: String) -> Bool {
        return !regexMatches(regex: regex).isEmpty
    }
}

final class Y2020_D4_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D4.part1(), 219)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D4.part2(), 127)
    }

    func testHeight() {
        XCTAssert("60in"._validHeight())
        XCTAssert("190cm"._validHeight())
        XCTAssertFalse("190in"._validHeight())
        XCTAssertFalse("190"._validHeight())
    }
}
