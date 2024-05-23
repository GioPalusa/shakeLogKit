//
//  ShakeLogExporter.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import Foundation
import OSLog

/// A structure responsible for exporting and reading logs.
public struct ShakeLogExporter {

	/// Exports logs to a file.
	/// - Parameter logs: The array of OSLogEntryLog to be exported.
	/// - Returns: The `Data` of the exported file.
	/// - Throws: An error if the file could not be written.
	public static func exportLogs(_ logs: [OSLogEntryLog]) async throws -> Data? {
		let logText = logs.map { logEntry in
			let dateFormatter = ISO8601DateFormatter()
			let dateStr = dateFormatter.string(from: logEntry.date)
			return """
			\(dateStr): t=\(logEntry.threadIdentifier): \(logEntry.level): \(logEntry.subsystem): \(logEntry.composedMessage)
			"""
		}.joined(separator: "\n")

		return logText.data(using: .utf8)
	}

	/// Reads logs from a file.
	/// - Parameter url: The URL of the file to be read.
	/// - Returns: An array of strings representing the log entries.
	/// - Throws: An error if the file could not be read.
	public static func readLogs(from url: URL) throws -> [String] {
		let logText = try String(contentsOf: url, encoding: .utf8)
		return logText.components(separatedBy: "\n")
	}
}
