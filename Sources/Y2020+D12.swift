import Babbage
import XCTest

extension Y2020 {

    enum D12 {

        static func part1() -> Int {
            return File.readLines(file: "2020-12.txt")
                .map { _Instruction($0) }
                .run { _Ship(instructions: $0) }
                .distance
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-12.txt")
                .map { _Instruction($0) }
                .run { _ShipV2(instructions: $0) }
                .distance
        }
    }
}

private struct _Instruction {

    let direction: Character
    let distance: Int

    init(_ raw: String) {
        direction = raw[0]
        distance = Int(raw[1...])!
    }
}

private final class _Ship {

    private var _direction = 90
    private var _x = 0
    private var _y = 0

    init(instructions: [_Instruction]) {
        for instruction in instructions {
            switch instruction.direction {
            case "N":
                _y += instruction.distance
            case "S":
                _y -= instruction.distance
            case "E":
                _x += instruction.distance
            case "W":
                _x -= instruction.distance
            case "L":
                _direction = (_direction - instruction.distance + 360) % 360
            case "R":
                _direction = (_direction + instruction.distance + 360) % 360
            case "F":
                _moveForward(distance: instruction.distance)
            default:
                fatalError()
            }
        }
    }

    var distance: Int {
        return _x.absoluteValue + _y.absoluteValue
    }

    private func _moveForward(distance: Int) {
        switch _direction {
        case 0:
            _y += distance
        case 90:
            _x += distance
        case 180:
            _y -= distance
        case 270:
            _x -= distance
        default:
            fatalError();
        }
    }
}

private final class _ShipV2 {

    private var _x = 0
    private var _y = 0
    private var _waypointX = 10
    private var _waypointY = 1

    init(instructions: [_Instruction]) {
        for instruction in instructions {
            switch instruction.direction {
            case "N":
                _waypointY += instruction.distance
            case "S":
                _waypointY -= instruction.distance
            case "E":
                _waypointX += instruction.distance
            case "W":
                _waypointX -= instruction.distance
            case "L":
                _rotateLeft(times: instruction.distance / 90)
            case "R":
                _rotateRight(times: instruction.distance / 90)
            case "F":
                _x += _waypointX * instruction.distance
                _y += _waypointY * instruction.distance
            default:
                fatalError()
            }
        }
    }

    var distance: Int {
        return _x.absoluteValue + _y.absoluteValue
    }

    private func _rotateLeft(times: Int) {
        for _ in 0 ..< times {
            swap(&_waypointX, &_waypointY)
            _waypointX = -_waypointX
        }
    }

    private func _rotateRight(times: Int) {
        for _ in 0 ..< times {
            swap(&_waypointX, &_waypointY)
            _waypointY = -_waypointY
        }
    }
}


final class Y2020_D12_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D12.part1(), 1482)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D12.part2(), 48739)
    }

    func testExample() {
        let result = ["F10", "N3", "F7", "R90", "F11"]
            .map { _Instruction($0) }
            .run { _Ship(instructions: $0) }
            .distance

        XCTAssertEqual(result, 25)
    }

    func testExample2() {
        let result = ["F10", "N3", "F7", "R90", "F11"]
            .map { _Instruction($0) }
            .run { _ShipV2(instructions: $0) }
            .distance

        XCTAssertEqual(result, 286)
    }
}
