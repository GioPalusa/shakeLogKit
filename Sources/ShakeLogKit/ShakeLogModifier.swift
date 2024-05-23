//
//  ShakeLogModifier.swift
//
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI

public struct ShakeLogModifier: ViewModifier {
	private let settings: ShakeLogSettings?
	@State private var showingLogs = false

	public init(settings: ShakeLogSettings?) {
		self.settings = settings
	}

	public func body(content: Content) -> some View {
		content
			.onShakeGesture {
				guard settings?.isEnabled ?? false else { return }
				if settings?.useShake ?? true {
					if settings?.shouldShowLogs == nil {
						showingLogs = true
					} else {
						settings?.shouldShowLogs = true
					}
				}
			}
			.sheet(isPresented: bindingToShowLogs) {
				ShakeLogView(timeInterval: settings?.timeInterval ?? -3600, subsystem: settings?.subsystem)
			}
			.environment(\.shakeLogSettings, settings)
	}

	private var bindingToShowLogs: Binding<Bool> {
		if let shouldShowLogs = settings?.shouldShowLogs {
			return Binding(get: { shouldShowLogs }, set: { settings?.shouldShowLogs = $0 })
		} else {
			return $showingLogs
		}
	}
}

public extension View {
	func enableShakeLogging(_ settings: ShakeLogSettings? = nil) -> some View {
		self.modifier(ShakeLogModifier(settings: settings))
	}
}
