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

	func testExtractLogMessageSegmentsParsesEmbeddedJSONObject() {
		let message = "RESPONSE: 200\nHeaders:\n{\"Content-Type\":\"application/json\"}\nBody done"

		let segments = extractLogMessageSegments(from: message)

		XCTAssertEqual(segments.count, 3)
		XCTAssertEqual(segments[0], .text("RESPONSE: 200\nHeaders:\n"))
		if case .json(let json) = segments[1] {
			XCTAssertTrue(json.contains("\"Content-Type\""))
		} else {
			XCTFail("Expected JSON segment")
		}
		XCTAssertEqual(segments[2], .text("\nBody done"))
	}

	func testExtractLogMessageSegmentsParsesEmbeddedJSONArray() {
		let message = "Body:\n[{\"id\":1},{\"id\":2}]"

		let segments = extractLogMessageSegments(from: message)

		XCTAssertEqual(segments.count, 2)
		XCTAssertEqual(segments[0], .text("Body:\n"))
		if case .json(let json) = segments[1] {
			XCTAssertTrue(json.contains("\"id\""))
		} else {
			XCTFail("Expected JSON array segment")
		}
	}

	func testExtractLogMessageSegmentsFallsBackToTextForInvalidJSON() {
		let message = "Not JSON: {missing:true"

		let segments = extractLogMessageSegments(from: message)

		XCTAssertEqual(segments, [.text(message)])
	}

}
