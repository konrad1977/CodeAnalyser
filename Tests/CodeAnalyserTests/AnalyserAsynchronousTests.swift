import XCTest
@testable import CodeAnalyser

final class CodeAnalyserAsynchronousTests: XCTestCase {

	func testEmptyResultAsync() {

		let expectation = XCTestExpectation(description: "Statistics")

		CodeAnalyser()
			.statisticsAsync(from: "/")
			.run { (langs, stats) in
				XCTAssertEqual(langs.count, 4)
				XCTAssertTrue(stats.isEmpty, "Statistics not empty")
				expectation.fulfill()
		}

		wait(for: [expectation], timeout: 2)
	}

	func testAnalyserImportsSwiftAsync() {

		let expectation = XCTestExpectation(description: "Imports")

		CodeAnalyser()
			.analyseSourcefileAsync(
                path: "/",
				filename: "imports",
				filedata: swiftImports[...],
				filetype: .swift
			).run { filinfo in
				XCTAssertEqual(filinfo.imports, 2)
				expectation.fulfill()
			}
		wait(for: [expectation], timeout: 2)

	}

	func testAnalyserExtensionsSwiftAsync() {

		let expectation = XCTestExpectation(description: "Extensions")

		CodeAnalyser()
			.analyseSourcefileAsync(
                path: "/",
				filename:"extensions",
				filedata: extensions[...],
				filetype: .swift
			).run { fileinfo in
				XCTAssertEqual(fileinfo.extensions, 3)
				expectation.fulfill()

			}
		wait(for: [expectation], timeout: 2)
	}

	func testAnalyserClassesSwiftAsync() {

		let expectation = XCTestExpectation(description: "Classes")

		CodeAnalyser()
			.analyseSourcefileAsync(
                path: "/",
                filename: "classes",
				filedata: classes[...],
				filetype: .swift
			).run { fileinfo in
				XCTAssertEqual(fileinfo.classes, 2)
				expectation.fulfill()
			}
		wait(for: [expectation], timeout: 2)
	}

	func testAnalyserFunctionsSwiftAsync() {

		let expectation = XCTestExpectation(description: "Functions")

		CodeAnalyser()
			.analyseSourcefileAsync(
                path: "/",
				filename: "functions",
				filedata: functions[...],
				filetype: .swift
			).run { fileinfo in
				XCTAssertEqual(fileinfo.functions, 3)
				expectation.fulfill()
			}
		wait(for: [expectation], timeout: 2)
	}

	func testAnalyserFullFileSwiftAsync() {

		let expectation = XCTestExpectation(description: "Functions")

		CodeAnalyser()
			.analyseSourcefileAsync(
                path: "/",
				filename: "fullfile",
				filedata: fullFile[...],
				filetype: .swift
			).run { fileinfo in
				XCTAssertEqual(fileinfo.imports, 1)
				XCTAssertEqual(fileinfo.classes, 0)
				XCTAssertEqual(fileinfo.structs, 1)
				XCTAssertEqual(fileinfo.extensions, 2)
				XCTAssertEqual(fileinfo.functions, 11)
				XCTAssertEqual(fileinfo.enums, 1)
				XCTAssertEqual(fileinfo.linecount, 30)
				XCTAssertEqual(fileinfo.filetype, .swift)
				expectation.fulfill()
			}
		wait(for: [expectation], timeout: 2)
	}

	static var allTests = [
		("emptyResult", testEmptyResultAsync),
		("imports", testAnalyserImportsSwiftAsync),
		("extensions", testAnalyserExtensionsSwiftAsync),
		("classes", testAnalyserClassesSwiftAsync),
		("functions", testAnalyserFunctionsSwiftAsync),
		("fullfile", testAnalyserFullFileSwiftAsync)
	]
}
