//
//  FiletypeTests.swift
//  CodeAnalyserTests
//
//  Created by Mikael Konradsson on 2021-03-21.
//

import XCTest
@testable import CodeAnalyser

final class FiletypeTests: XCTestCase {

	func testFiletypeSwift() {
		let filetype: Filetype = .swift
		XCTAssertTrue(filetype == .swift, "Should be swift filetype")
	}

	func testFiletypeKotlin() {
		let filetype: Filetype = .kotlin
		XCTAssertTrue(filetype == .kotlin, "Should be kotlin filetype")
	}

	func testFiletypeObjectiveC() {
		let filetype: Filetype = .objectiveC
		XCTAssertTrue(filetype == .objectiveC, "Should be kotlin filetype")
	}

	func testFiletypeObjectiveCAndSwift() {
		let filetype: Filetype = [.objectiveC, .swift]
		XCTAssertTrue(filetype.contains(.objectiveC), "Should contain objectiveC filetype")
		XCTAssertTrue(filetype.contains(.swift), "Should contain objectiveC filetype")
		XCTAssertTrue(filetype.contains(.kotlin) == false, "Should not contain Kotlin filetype")
	}

	func testFiletypeEmpty() {
		let filetype: Filetype = .empty
		XCTAssertTrue(filetype.contains(.objectiveC) == false, "Should not contain objectiveC filetype")
		XCTAssertTrue(filetype.contains(.swift) == false, "Should not contain objectiveC filetype")
		XCTAssertTrue(filetype.contains(.kotlin) == false, "Should not contain Kotlin filetype")
	}
}
