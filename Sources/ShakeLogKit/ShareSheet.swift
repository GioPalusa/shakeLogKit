//
//  ShareSheet.swift
//
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import UIKit
import UniformTypeIdentifiers

/// Presents a share sheet for the given data with optional file name and file type.
/// - Parameters:
///   - data: The data to be shared.
///   - fileName: The name of the file to be shared (optional).
///   - fileType: The UTType representing the type of file being shared (optional).
public func presentShareSheet(_ data: Data?, fileName: String? = nil, fileType: UTType? = nil) {
	guard let data = data else {
		ShakeLogFileManager.shared.log("Missing data for share sheet", level: .error)
		return
	}

	var activityItems: [Any] = []

	// If fileName is provided, create a temporary file and add file URL to the activity items
	if let fileName = fileName {
		let temporaryDirectory = FileManager.default.temporaryDirectory
		let fileURL = temporaryDirectory.appendingPathComponent(fileName)
		do {
			try data.write(to: fileURL)
			activityItems.append(fileURL)
		} catch {
			ShakeLogFileManager.shared.log("Failed to write data to file: \(error)", level: .error)
			return
		}
	} else {
		activityItems.append(data)
	}

	// Optionally add fileType to activity items
	if let fileType = fileType {
		activityItems.append(fileType)
	}

	let activityView = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

	guard let topViewController = UIApplication.shared.topViewController() else {
		return
	}
	let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
	topViewController.present(activityViewController, animated: true, completion: nil)
}

extension UIApplication {
	/// Finds the top-most view controller in the app.
	func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
		.compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
		.first) -> UIViewController?
	{
		if let nav = base as? UINavigationController {
			return topViewController(base: nav.visibleViewController)
		}
		if let tab = base as? UITabBarController {
			if let selected = tab.selectedViewController {
				return topViewController(base: selected)
			}
		}
		if let presented = base?.presentedViewController {
			return topViewController(base: presented)
		}
		return base
	}
}
