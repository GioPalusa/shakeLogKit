# ShakeLogKit

`ShakeLogKit` is a Swift package that enables logging and viewing logs in your iOS application when the device is shaken. This package leverages `OSLog` for logging and provides a simple `ViewModifier` to display the logs in a SwiftUI sheet.

## Features

- Detect shake gestures and trigger custom actions.
- Log messages using `OSLog`.
- Display logs in a SwiftUI sheet when the device is shaken.
- Customize logging settings including time intervals, subsystem filters, and shake gesture usage.

## Requirements

- iOS 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

1. In Xcode, open your project and navigate to `File > Swift Packages > Add Package Dependency`.
2. Enter the repository URL for ShakeLogKit.
3. Follow the prompts to add the package to your project.

Alternatively, add the following line to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/GioPalusa/shakeLogKit/", branch: "main")
]
```

## Usage

### Basic Setup

1. **Import ShakeLogKit:**

   ```swift
   import ShakeLogKit
   ```

2. **Enable Shake Logging:**

   In your SwiftUI view, apply the `enableShakeLogging` modifier:

   ```swift
   struct ContentView: View {
       @State private var showingLogs = false
       
       var body: some View {
           Text("Hello, World!")
               .enableShakeLogging(showingLogs: $showingLogs)
       }
   }
   ```

   This will use the default settings which logs messages and displays them in a sheet when the device is shaken.

### Advanced Setup

1. **Define ShakeLogSettings:**

   Create an instance of `ShakeLogSettings` to customize the logging behavior:

   ```swift
   import SwiftUI
   import ShakeLogKit

   @State private var shouldShowLogs: Bool? = nil

   let settings = ShakeLogSettings(
       timeInterval: -3600,            // Fetch logs from the last hour
       useShake: true,                 // Enable shake gesture to show logs
       subsystem: "com.example.app",   // Filter logs by subsystem
       shouldShowLogs: $shouldShowLogs // Binding to control log display
   )
   ```

2. **Apply Settings:**

   Pass the settings and the `isEnabled` binding to the `enableShakeLogging` modifier:

   ```swift
   struct ContentView: View {
       @State private var shouldShowLogs: Bool? = nil
       @State private var isEnabled = true
       @State private var showingLogs = false

       var body: some View {
           Text("Hello, World!")
               .enableShakeLogging(
                   ShakeLogSettings(
                       timeInterval: -3600,
                       useShake: true,
                       subsystem: "com.example.app",
                       shouldShowLogs: $shouldShowLogs
                   ),
                   isEnabled: $isEnabled,
                   showingLogs: $showingLogs
               )
       }
   }
   ```

### Logging Messages

You can use the `ShakeLogFileManager` to log messages, but this is not required if you are already using `OSLog` in your project:

```swift
import ShakeLogKit

ShakeLogFileManager.shared.log("This is a test log message.")
```

### Viewing Logs

When the device is shaken, the logs will be displayed in a SwiftUI sheet if logging is enabled. The logs can be filtered by type and searched using the provided interface.

## Example

Here is a complete example of how to set up and use `ShakeLogKit` in an iOS application:

```swift
import SwiftUI
import ShakeLogKit

@main
struct MyApp: App {
    @State private var shouldShowLogs: Bool? = nil
    @State private var isEnabled = true
    @State private var showingLogs = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .enableShakeLogging(
                    ShakeLogSettings(
                        timeInterval: -3600,
                        useShake: true,
                        subsystem: "com.example.app",
                        shouldShowLogs: $shouldShowLogs
                    ),
                    isEnabled: $isEnabled,
                    showingLogs: $showingLogs
                )
        }
    }
}

struct ContentView: View {
    @State private var shouldShowLogs: Bool? = nil
    @State private var isEnabled = true
    @State private var showingLogs = false

    var body: some View {
        VStack {
            Text("Main Content")
                .padding()

            Button("Log a Message") {
                ShakeLogFileManager.shared.log("This is a test log message.")
            }
        }
        .enableShakeLogging(
            ShakeLogSettings(
                timeInterval: -3600,
                useShake: true,
                subsystem: "com.example.app",
                shouldShowLogs: $shouldShowLogs
            ),
            isEnabled: $isEnabled,
            showingLogs: $showingLogs
        )
    }
}
```

## License

ShakeLogKit is released under the MIT license.

```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ShakeLogKit",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "ShakeLogKit",
			targets: ["ShakeLogKit"])
	],
	targets: [
		.target(
			name: "ShakeLogKit",
			dependencies: []),
		.testTarget(
			name: "ShakeLogKitTests",
			dependencies: ["ShakeLogKit"])
	]
)
```

Feel free to make any additional adjustments to fit your specific needs.
