import XCTest
@testable import CodeAnalyser

final class TodoAnalyserTests: XCTestCase {

    func testParseTodo() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "onetodo",
            data: commentTodo[...],
            fileType: .swift
        )

        let todos = CodeAnalyser()
            .analysTodo(in: sourceFile)
            .unsafeRun()

        XCTAssertEqual(todos.comments[0].comment, "Hello one")
        XCTAssertEqual(todos.comments[1].comment, "Hello two")
        XCTAssertEqual(todos.comments[2].comment, "Hello three")
    }

//    func testSearchString() {
//        let str = commentTodo[...]
//
//        let (tmpString, index) = str.stringInfoBefore(":")
//        let isTodo = tmpString.contains("TODO")
//
//        XCTAssertTrue(isTodo)
//
//        if let restIndex = index {
//            if let newLineIndex = str.range(of: "\n") {
//                let message = String(str)
//                    .substring(to: newLineIndex.lowerBound)
//                    .dropFirst(restIndex)
//                    .trimmingCharacters(in: .whitespacesAndNewlines)
//                XCTAssertEqual(message, "Hello world")
//            }
//        }
//    }
}
