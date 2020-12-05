import Babbage
import XCTest

extension Y2020 {

    enum D5 {

        static func part1() -> Int {
            return File.readLines(file: "2020-5.txt")
                .map { $0._seatId() }
                .max()!
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-5.txt")
                .map { $0._seatId() }
                .sorted()
                .paired()
                .first { $0.left + 2 == $0.right }!
                .left + 1
        }
    }
}

extension String {

    fileprivate func _seatId() -> Int {
        let row = _search(in: 0 ... 128, using: prefix(7)) { $0 == "F" }
        let column = _search(in: 0 ... 8, using: suffix(3)) { $0 == "L" }

        return row * 8 + column
    }

    fileprivate func _search(in range: ClosedRange<Int>, using str: Substring, predicate: (Character) -> Bool) -> Int {
        guard !str.isEmpty, range.count > 1 else {
            return range.lowerBound
        }

        let distance = range.count / 2
        let partition = predicate(str.first!)
            ? range.lowerBound ... range.upperBound - distance
            : range.lowerBound + distance ... range.upperBound

        return _search(in: partition, using: str.dropFirst(), predicate: predicate)
    }
}

final class Y2020_D5_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D5.part1(), 953)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D5.part2(), 615)
    }
}
