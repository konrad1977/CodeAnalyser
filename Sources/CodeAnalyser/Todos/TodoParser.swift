import Foundation
import Funswift

extension String.SubSequence {

    func stringInfoBefore(_ delimiter: Character) -> (String, Int?) {
        if let index = firstIndex(of: delimiter) {
            return (String(prefix(upTo: index)), index.utf16Offset(in: self) + 1)
        } else {
            return ("", nil)
        }
    }
}

struct TodoParser {

    static func todosCommentsIn(sourceFile: String.SubSequence) -> IO<[Comment]> {
        IO {
            guard sourceFile.range(of: "TODO:") != nil || sourceFile.range(of: "FIXME:") != nil
            else { return [] }

            let lines = sourceFile.components(separatedBy: .newlines)

            guard lines.isEmpty == false
            else { return [] }

            var comments: [Comment] = []
            for (index, currentLine) in lines.enumerated() {
                if let comment = TodoParser.parseLine(index: index, source: currentLine[...]) {
                    comments.append(comment)
                }
            }
            return comments
        }
    }

    private static func parseLine(index: Int, source: String.SubSequence) -> Comment? {
        let (tmpString, todoIndex) = source.stringInfoBefore(":")
        let isTodo = tmpString.contains("TODO") || tmpString.contains("FIXME")
        guard isTodo == true
        else { return nil }

        guard let restIndex = todoIndex
        else { return nil }

        let message = String(source)
            .dropFirst(restIndex)
            .trimmingCharacters(in: .whitespaces)

        return message.isEmpty || message.count < 3
        ? nil
        : Comment(line: index + 1, comment: message)
    }
}
