# ShakeLogKit

`ShakeLogKit` is a Swift package that enables logging and viewing logs in your iOS application when the device is shaken. This package leverages `OSLog` for logging and provides a simple `ViewModifier` to display the logs in a SwiftUI sheet.

## Features

- Detect shake gestures and trigger custom actions.
- Log messages using `OSLog`.
- Display logs in a SwiftUI sheet when the device is shaken.

## Requirements

- iOS 15.0+
- Swift 5.3+

## Installation

### Swift Package Manager

1. In Xcode, open your project and navigate to `File > Swift Packages > Add Package Dependency`.
2. Enter the repository URL for ShakeLogKit.
3. Follow the prompts to add the package to your project.

Alternatively, add the following line to your `Package.swift`:

```swift
dependencies: [
	.package(url: "https://github.com/your-repo/ShakeLogKit.git", from: "1.0.0")
]
