import Babbage
import Foundation

typealias Point = Pair<Int, Int>

enum File {

    static func read(file: String) -> String {
        guard let url = Bundle.module.url(forResource: file, withExtension: nil, subdirectory: "Resources") else {
            fatalError()
        }

        var content = try! String(contentsOf: url)

        if content.last!.isNewline {
            content.removeLast()
        }

        return content
    }

    static func readLines(file: String) -> [String] {
        return read(file: file)
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
    }
}
