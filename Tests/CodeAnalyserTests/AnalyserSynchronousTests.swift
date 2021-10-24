import XCTest
@testable import CodeAnalyser

final class CodeAnalyserSynchronousTests: XCTestCase {

    func testEmptyResult() {
		let (langs, statistics) = CodeAnalyser()
			.statistics(from: "/")
			.unsafeRun()

		XCTAssertEqual(langs.count, 0)
		XCTAssertTrue(statistics.isEmpty, "Statistics not empty")
    }

	func testAnalyserImportsSwift() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "imports",
            data: swiftImports[...],
            fileType: .swift
        )
		let fileInfo = CodeAnalyser()
			.analyseSourcefile(sourceFile: sourceFile)
		XCTAssertEqual(fileInfo.unsafeRun().imports, 2)
	}

	func testAnalyserExtensionsSwift() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "extensions",
            data: extensions[...],
            fileType: .swift
        )
		let fileInfo = CodeAnalyser()
			.analyseSourcefile(sourceFile: sourceFile)
		XCTAssertEqual(fileInfo.unsafeRun().extensions, 3)
	}

	func testAnalyserClassesSwift() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "classes",
            data: classes[...],
            fileType: .swift
        )
		let fileInfo = CodeAnalyser()
			.analyseSourcefile(sourceFile: sourceFile)
		XCTAssertEqual(fileInfo.unsafeRun().classes, 2)
	}

	func testAnalyserFunctionsSwift() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "functions",
            data: functions[...],
            fileType: .swift
        )
		let fileInfo = CodeAnalyser()
			.analyseSourcefile(sourceFile: sourceFile)
		XCTAssertEqual(fileInfo.unsafeRun().functions, 3)
	}

	func testAnalyserFullFileSwift() {
        let sourceFile = SourceFile(
            path: "/mocked",
            name: "fullfile",
            data: fullFile[...],
            fileType: .swift
        )

		let fileInfo = CodeAnalyser().analyseSourcefile(sourceFile: sourceFile)
		XCTAssertEqual(fileInfo.unsafeRun().imports, 1)
		XCTAssertEqual(fileInfo.unsafeRun().classes, 0)
		XCTAssertEqual(fileInfo.unsafeRun().structs, 1)
		XCTAssertEqual(fileInfo.unsafeRun().extensions, 2)
		XCTAssertEqual(fileInfo.unsafeRun().functions, 11)
		XCTAssertEqual(fileInfo.unsafeRun().enums, 1)
		XCTAssertEqual(fileInfo.unsafeRun().linecount, 30)
		XCTAssertEqual(fileInfo.unsafeRun().filetype, .swift)
	}

    static var allTests = [
        ("emptyResult", testEmptyResult),
		("imports", testAnalyserImportsSwift),
		("extensions", testAnalyserExtensionsSwift),
		("classes", testAnalyserClassesSwift),
		("functions", testAnalyserFunctionsSwift),
		("fullfile", testAnalyserFullFileSwift)
    ]
}
