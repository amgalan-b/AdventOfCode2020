import Babbage
import XCTest

extension Y2020 {

    enum D8 {

        static func part1() -> Int {
            return File.readLines(file: "2020-8.txt")
                .map { _Instruction($0) }
                ._accumulate { visitedIndices, index, _ in visitedIndices.contains(index) }!
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-8.txt")
                .map { _Instruction($0) }
                ._swappedModifications()
                .compactMap { instructions in
                    instructions._accumulate { _, _, isLast in isLast } exitIf: { $0.contains($1) }
                }
                .first!
        }
    }
}

private struct _Instruction {

    var command: String
    var value: Int

    init(_ raw: String) {
        let parts = raw.components(separatedBy: " ")
        command = parts[0]
        value = Int(parts[1])!
    }
}

extension Array where Element == _Instruction {

    fileprivate func _accumulate(
        until accumulatingPredicate: (Set<Int>, Int, Bool) -> Bool,
        exitIf exitPredicate: ((Set<Int>, Int) -> Bool) = { _, _ in false }
    ) -> Int? {
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()

        while !accumulatingPredicate(visited, index, index == count - 1) {
            if exitPredicate(visited, index) {
                return nil
            }

            let instruction = self[index]
            switch instruction.command {
            case "acc":
                accumulator += instruction.value
            case "jmp":
                index += instruction.value - 1
            default:
                break
            }

            visited.insert(index)
            index = (index + 1) % count
        }

        return accumulator
    }

    fileprivate func _swappedModifications() -> [[_Instruction]] {
        var result = [[_Instruction]]()

        for (index, instruction) in enumerated() {
            var copy = self
            switch instruction.command {
            case "jmp":
                copy[index].command = "nop"
                result.append(copy)
            case "nop":
                copy[index].command = "jmp"
                result.append(copy)
            default:
                continue
            }
        }

        return result
    }
}

final class Y2020_D8_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D8.part1(), 1949)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D8.part2(), 2092)
    }
}
