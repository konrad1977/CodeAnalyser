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

    func testParseWarnings() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "warnings",
            data: warningsTodo[...],
            fileType: .swift
        )

        let todos = CodeAnalyser()
            .analysTodo(in: sourceFile)
            .unsafeRun()

        XCTAssertEqual(todos.comments[0].comment, "Something is totally wrong")
    }
}
