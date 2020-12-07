import Babbage
import SwiftGraph
import XCTest

extension Y2020 {

    enum D7 {

        static func part1() -> Int {
            return File.readLines(file: "2020-7.txt")
                .map { $0._parseRule() }
                ._makeGraph()
                .filter { !$0.dfs(from: $1, to: "shiny gold").isEmpty }
                .count
        }

        static func part2() -> Int {
            return File.readLines(file: "2020-7.txt")
                .map { $0._parseRule() }
                ._makeGraph()
                ._totalBags(for: "shiny gold")
        }
    }
}

private struct _Rule {

    let name: String
    let children: [String: Int]
}

extension String {

    fileprivate func _parseRule() -> _Rule {
        var colors = regexMatches(regex: "([0-9] |^)[a-z]+ [a-z]+")
            .map { $0.match }

        return _Rule(
            name: colors.removeFirst(),
            children: colors
                .map { ($0[2...], Int($0[0])!) }
                .run { Dictionary(uniqueKeysWithValues: $0) }
        )
    }
}

extension Array where Element == _Rule {

    fileprivate func _makeGraph() -> WeightedGraph<String, Int> {
        let graph = WeightedGraph<String, Int>(vertices: map { $0.name })

        for rule in self {
            for child in rule.children {
                graph.addEdge(from: rule.name, to: child.key, weight: child.value, directed: true)
            }
        }

        return graph
    }
}

extension WeightedGraph where V == String, W == Int {

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
            .map { $0._parseRule() }
            ._makeGraph()
            ._totalBags(for: "shiny gold")

        XCTAssertEqual(result, 126)
    }
}
