//
//  LogFileManager.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import Foundation
import OSLog

public class ShakeLogFileManager {
	public static let shared = ShakeLogFileManager()
	private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ShakeLog")

	private init() {}

	public func log(_ message: String) {
		logger.log("\(message, privacy: .public)")
	}

	public func fetchShakeLogs(timeInterval: TimeInterval, subsystem: String? = nil) async -> [OSLogEntryLog] {
		guard let logStore = try? OSLogStore(scope: .currentProcessIdentifier) else {
			return []
		}
		let position = logStore.position(timeIntervalSinceLatestBoot: timeInterval)

		if let entries = try? logStore.getEntries(at: position) {
			let logs: [OSLogEntryLog] = entries.compactMap { entry in
				if let logEntry = entry as? OSLogEntryLog {
					return logEntry
				}
				return nil
			}
			return logs
		} else {
			return []
		}
	}
}
