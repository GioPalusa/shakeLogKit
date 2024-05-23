//
//  ShakeLogModifier.swift
//
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI

public struct ShakeLogModifier: ViewModifier {
	private let settings: ShakeLogSettings?
	@Binding private var isEnabled: Bool
	@State private var showingLogs = false

	init(settings: ShakeLogSettings?, isEnabled: Binding<Bool>) {
		self.settings = settings
		self._isEnabled = isEnabled
	}

	public func body(content: Content) -> some View {
		content
			.onShakeGesture {
				guard isEnabled else { return }
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
			return isEnabled ? $showingLogs : .constant(false)
		}
	}
}

public extension View {
	/// Enables shake logging on the view.
	/// - Parameter settings: The settings for configuring shake logging.
	/// - Parameter isEnabled: A binding if the feature is active or not. Defaults to true.
	/// - Returns: A view with shake logging enabled.
	func enableShakeLogging(_ settings: ShakeLogSettings? = nil, isEnabled: Binding<Bool> = .constant(true)) -> some View {
		self.modifier(ShakeLogModifier(settings: settings, isEnabled: isEnabled))
	}
}
