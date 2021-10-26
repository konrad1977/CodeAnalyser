import XCTest
import Funswift
@testable import CodeAnalyser

final class PredicateTests: XCTestCase {

    func testPathExcludes() {

        let fileFilter: PathFilter = .custom([""])

        let result = [
            "/project/path/importantfile.swift",
            "/pods/some/path/file.swift",
            ".ds_store"
        ]
        .filter(
            noneOf(fileFilter.query).contains
        )

        XCTAssertTrue(result.count == 1, "Should only include one item")
    }
}
