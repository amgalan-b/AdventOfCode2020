import Babbage
import SwiftGraph
import XCTest

extension Y2020 {

    enum D7 {

        static func part1() -> Int {
            return File.readLines(file: "2020-7.txt")
                .map { _Rule($0) }
                .run { WeightedGraph(rules: $0) }
                .filter { $0.pathExists(from: $1, to: "shiny gold") }
                .count
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-7.txt")
                .map { _Rule($0) }
                .run { WeightedGraph(rules: $0) }
                ._totalBags(for: "shiny gold")
        }
    }
}

private struct _Rule {

    let name: String
    let children: [String: Int]

    init(_ raw: String) {
        var colors = raw.regexMatches(regex: "([0-9] |^)[a-z]+ [a-z]+")
            .map { $0.match }

        name = colors.removeFirst()
        children = colors
            .map { ($0[2...], Int($0[0])!) }
            .run { Dictionary(uniqueKeysWithValues: $0) }
    }
}

extension WeightedGraph where V == String, W == Int {

    fileprivate convenience init(rules: [_Rule]) {
        self.init(vertices: rules.map { $0.name })

        for rule in rules {
            for child in rule.children {
                addEdge(from: rule.name, to: child.key, weight: child.value, directed: true)
            }
        }
    }

    fileprivate func _totalBags(for vertex: String) -> Int {
        let edges = edgesForVertex(vertex)!

        guard !edges.isEmpty else {
            return 0
        }

        return edges
            .map { $0.weight + $0.weight * _totalBags(for: vertexAtIndex($0.v)) }
            .sum()
    }
}

final class Y2020_D7_Tests: XCTestCase {

    func testPart1() {
        XCTAssertEqual(Y2020.D7.part1(), 316)
    }

    func testPart2() {
        XCTAssertEqual(Y2020.D7.part2(), 11310)
    }

    func testExample() {
        let result =
            """
            shiny gold bags contain 2 dark red bags.
            dark red bags contain 2 dark orange bags.
            dark orange bags contain 2 dark yellow bags.
            dark yellow bags contain 2 dark green bags.
            dark green bags contain 2 dark blue bags.
            dark blue bags contain 2 dark violet bags.
            dark violet bags contain no other bags.
            """
            .components(separatedBy: .newlines)
            .map { _Rule($0) }
            .run { WeightedGraph(rules: $0) }
            ._totalBags(for: "shiny gold")

        XCTAssertEqual(result, 126)
    }
}
