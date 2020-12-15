import Babbage
import XCTest

extension Y2020 {

    enum D15 {

        static func part1() -> Int {
            return File.read(file: "2020-15.txt")
                .components(separatedBy: ",")
                .map { Int($0)! }
                .run { _Memory($0) }
                .result(at: 2020)
        }

        static func part2() -> Int {
            return File.read(file: "2020-15.txt")
                .components(separatedBy: ",")
                .map { Int($0)! }
                .run { _Memory($0) }
                .result(at: 30_000_000)
        }
    }
}

private final class _Memory: Sequence, IteratorProtocol {

    typealias Element = Int

    private var _memory = [Int: Int]()
    private var _currentTurn = 0

    private let _initial: [Int]
    private var _latest = -1

    init(_ numbers: [Int]) {
        _initial = numbers
    }

    func result(at index: Int) -> Int {
        var result: Int?

        for _ in 0 ..< index {
            result = next()
        }

        return result!
    }

    func next() -> Int? {
        let result: Int

        if _currentTurn < _initial.count {
            result = _initial[_currentTurn]
        } else if let lastSeenTurn = _memory[_latest] {
            result = _currentTurn - lastSeenTurn
        } else {
            result = 0
        }

        _memory[_latest] = _currentTurn
        _latest = result
        _currentTurn += 1

        return result
    }
}

final class Y2020_D15_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D15.part1(), 852)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D15.part2(), 6007666)
    }

    func testExample() {
        let memory = _Memory([0, 3, 6])
        let result = Array(memory.prefix(10))

        XCTAssertEqual(result, [0, 3, 6, 0, 3, 3, 1, 0, 4, 0])
    }

    func testExample2() {
        XCTAssertEqual(_Memory([1, 3, 2]).result(at: 2020), 1)
        XCTAssertEqual(_Memory([2, 1, 3]).result(at: 2020), 10)
        XCTAssertEqual(_Memory([1, 2, 3]).result(at: 2020), 27)
        XCTAssertEqual(_Memory([2, 3, 1]).result(at: 2020), 78)
        XCTAssertEqual(_Memory([3, 2, 1]).result(at: 2020), 438)
        XCTAssertEqual(_Memory([3, 1, 2]).result(at: 2020), 1836)
    }
}
