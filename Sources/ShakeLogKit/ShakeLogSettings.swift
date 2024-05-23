//
//  ShakeLogSettings.swift
//  
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import SwiftUI

public struct ShakeLogSettings {
	public var timeInterval: TimeInterval
	public var useShake: Bool
	public var subsystem: String?
	@Binding public var shouldShowLogs: Bool?
	@Binding public var isEnabled: Bool

	public init(timeInterval: TimeInterval, useShake: Bool = true, subsystem: String? = nil, shouldShowLogs: Binding<Bool?> = .constant(nil), isEnabled: Binding<Bool> = .constant(true)) {
		self.timeInterval = timeInterval
		self.useShake = useShake
		self.subsystem = subsystem
		self._shouldShowLogs = shouldShowLogs
		self._isEnabled = isEnabled
	}
}

private struct ShakeLogSettingsKey: EnvironmentKey {
	static let defaultValue: ShakeLogSettings? = nil
}

public extension EnvironmentValues {
	var shakeLogSettings: ShakeLogSettings? {
		get { self[ShakeLogSettingsKey.self] }
		set { self[ShakeLogSettingsKey.self] = newValue }
	}
}
