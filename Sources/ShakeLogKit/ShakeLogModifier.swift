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
	@Binding private var showingLogs: Bool

	init(settings: ShakeLogSettings?, isEnabled: Binding<Bool>, showingLogs: Binding<Bool>) {
		self.settings = settings
		self._isEnabled = isEnabled
		self._showingLogs = showingLogs
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
			.fullScreenCover(isPresented: $showingLogs) {
				ShakeLogView(timeInterval: settings?.timeInterval ?? -3600, subsystem: settings?.subsystem, isPresented: $showingLogs)
			}
			.environment(\.shakeLogSettings, settings)
	}
}

public extension View {
	/// Enables shake logging on the view.
	/// - Parameters:
	///   - settings: The settings for configuring shake logging.
	///   - isEnabled: A binding to control if the feature is active or not. Defaults to true.
	///   - showingLogs: A binding to control the presentation of the logs view.
	/// - Returns: A view with shake logging enabled.
	func enableShakeLogging(_ settings: ShakeLogSettings? = nil, isEnabled: Binding<Bool> = .constant(true), showingLogs: Binding<Bool>) -> some View {
		self.modifier(ShakeLogModifier(settings: settings, isEnabled: isEnabled, showingLogs: showingLogs))
	}
}
