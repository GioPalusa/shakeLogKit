//
//  ShakeDetector.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI
import Combine

extension UIDevice {
	static let ShakeLogDeviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}

extension UIWindow {
	override open func motionEnded(_ motion: UIEvent.EventSubtype, with: UIEvent?) {
		guard motion == .motionShake else { return }

		NotificationCenter.default.post(name: UIDevice.ShakeLogDeviceDidShake, object: nil)
	}
}

struct ShakeGestureViewModifier: ViewModifier {
	// 1
	let action: () -> Void

	func body(content: Content) -> some View {
		content
		// 2
			.onReceive(NotificationCenter.default.publisher(for: UIDevice.ShakeLogDeviceDidShake)) { _ in
				action()
			}
	}
}

public extension View {
	func onShakeGesture(perform action: @escaping () -> Void) -> some View {
		modifier(ShakeGestureViewModifier(action: action))
	}
}
