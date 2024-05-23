//
//  ShakeLogSettings.swift
//  
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import SwiftUI

public struct ShakeLogSettings {
	/// The time interval to fetch logs from.
	public var timeInterval: TimeInterval
	/// Whether to use shake gesture to trigger log display.
	public var useShake: Bool
	/// Subsystem name to filter logs by.
	public var subsystem: String?
	/// Binding to control whether the logs should be shown.
	@Binding public var shouldShowLogs: Bool?

	/// Initializes a new instance of ShakeLogSettings.
	/// - Parameters:
	///   - timeInterval: The time interval to fetch logs from.
	///   - useShake: Whether to use shake gesture to trigger log display.
	///   - subsystem: Subsystem name to filter logs by.
	///   - shouldShowLogs: Binding to control whether the logs should be shown.
	public init(timeInterval: TimeInterval, useShake: Bool = true, subsystem: String? = nil, shouldShowLogs: Binding<Bool?> = .constant(nil)) {
		self.timeInterval = timeInterval
		self.useShake = useShake
		self.subsystem = subsystem
		self._shouldShowLogs = shouldShowLogs
	}
}

private struct ShakeLogSettingsKey: EnvironmentKey {
	static let defaultValue: ShakeLogSettings? = nil
}

public extension EnvironmentValues {
	/// ShakeLogSettings environment value.
	var shakeLogSettings: ShakeLogSettings? {
		get { self[ShakeLogSettingsKey.self] }
		set { self[ShakeLogSettingsKey.self] = newValue }
	}
}
