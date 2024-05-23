//
//  File.swift
//  
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import UIKit
import UniformTypeIdentifiers

/// Presents a share sheet for the given file URL.
/// - Parameter fileURL: The URL of the file to be shared.
internal func presentShakeShareSheet(fileURL: URL) {
	let activityView = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
	let scenes = UIApplication.shared.connectedScenes
	if let windowScene = scenes.first as? UIWindowScene,
	   let window = windowScene.windows.first {
		window.rootViewController?.present(activityView, animated: true, completion: nil)
	}
}
