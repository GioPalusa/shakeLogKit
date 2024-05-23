//
//  LogFileManager.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import Foundation
import OSLog

public class LogFileManager {
	public static let shared = LogFileManager()
	private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ShakeLog")

	private init() {}

	public func log(_ message: String) {
		logger.log("\(message, privacy: .public)")
	}

	public func fetchLogs(completion: @escaping ([String]) -> Void) {
		let logStore = try? OSLogStore(scope: .currentProcessIdentifier)
		let position = logStore?.position(timeIntervalSinceLatestBoot: -3600) // Fetch logs from the last hour

		if let entries = try? logStore?.getEntries(at: position) {
			let logs = entries.compactMap { entry in
				if let logEntry = entry as? OSLogEntryLog {
					return "[\(logEntry.date)] \(logEntry.composedMessage)"
				}
				return nil
			}
			completion(logs)
		} else {
			completion(["Failed to fetch logs."])
		}
	}
}
