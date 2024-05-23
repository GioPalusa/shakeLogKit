//
//  ShakeLogModifier.swift
//
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI

public struct ShakeLogModifier: ViewModifier {
	@State private var showingLogs = false

	public init() {}

	public func body(content: Content) -> some View {
		content
			.onShakeGesture {
				showingLogs = true
			}
			.sheet(isPresented: $showingLogs) {
				ShakeLogView()
			}
	}
}

public extension View {
	func enableShakeLogging() -> some View {
		modifier(ShakeLogModifier())
	}
}

private struct WindowAccessor: UIViewRepresentable {
	var callback: (UIWindow) -> Void

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		DispatchQueue.main.async {
			if let window = view.window {
				callback(window)
			}
		}
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {}
}
