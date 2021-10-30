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
            guard sourceFile.range(of: "TODO:") != nil
                    || sourceFile.range(of: "FIXME:") != nil
                    || sourceFile.range(of: "#warning(") != nil
            else { return [] }

            let lines = sourceFile.components(separatedBy: .newlines)

            var comments: [Comment] = []
            for (index, currentLine) in lines.enumerated() {
                if isTodo(source: currentLine[...]) {
                    TodoParser.parseTodo(index: index, source: currentLine[...])
                        .flatMap { comments.append($0) }
                }
                if isWarning(source: currentLine[...]) {
                    TodoParser.parseWarning(index: index, source: currentLine[...])
                        .flatMap { comments.append($0) }
                }
            }
            return comments
        }
    }

    private static func isTodo(source: String.SubSequence) -> Bool {
        let trimmed = source
            .components(separatedBy: .whitespaces)
            .joined()
        return String(trimmed).hasPrefix("//TODO:") || String(trimmed).hasPrefix("//FIXME:")
    }

    private static func isWarning(source: String.SubSequence) -> Bool {
        source
            .trimmingCharacters(in: .whitespaces)
            .hasPrefix("#warning")
    }

    private static func parseWarning(index: Int, source: String.SubSequence) -> Comment? {
        guard let todoIndex = source.lastIndex(of: "(")
        else { return nil }
        
        let message = String(source[todoIndex ... source.index(before: source.endIndex)])
            .dropFirst(2)
            .dropLast(2)
            .trimmingCharacters(in: .whitespaces)

        return message.isEmpty ? nil : Comment(line: index + 1, comment: message)
    }

    private static func parseTodo(index: Int, source: String.SubSequence) -> Comment? {
        let (tmpString, todoIndex) = source.stringInfoBefore(":")

        guard (tmpString.contains("TODO") || tmpString.contains("FIXME")) == true, let restIndex = todoIndex
        else { return nil }

        let message = String(source)
            .dropFirst(restIndex)
            .trimmingCharacters(in: .whitespaces)

        return message.isEmpty || message.count < 3 ? nil : Comment(line: index + 1, comment: message)
    }
}
