import XCTest
@testable import ShakeLogKit

final class ShakeLogKitTests: XCTestCase {
	func testPrettyPrintJSONFormatsInput() {
		let json = "{\"b\":2,\"a\":1}".data(using: .utf8)!

		let result = prettyPrintJSON(json)

		XCTAssertNotNil(result)
		XCTAssertTrue(result?.contains("\n") == true)
		XCTAssertTrue(result?.contains("\"a\"") == true)
		XCTAssertTrue(result?.contains("\"b\"") == true)
	}

	func testPrettyPrintJSONReturnsNilForInvalidInput() {
		let invalidJSON = "not json".data(using: .utf8)!

		let result = prettyPrintJSON(invalidJSON)

		XCTAssertNil(result)
	}

	func testReadLogsReturnsLineSeparatedEntries() throws {
		let tempURL = FileManager.default.temporaryDirectory
			.appendingPathComponent(UUID().uuidString)
			.appendingPathExtension("log")
		let content = "first\nsecond\nthird"
		try content.write(to: tempURL, atomically: true, encoding: .utf8)
		defer { try? FileManager.default.removeItem(at: tempURL) }

		let logs = try ShakeLogExporter.readLogs(from: tempURL)

		XCTAssertEqual(logs, ["first", "second", "third"])
	}
}
