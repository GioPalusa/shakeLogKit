// swift-tools-version: 5.10
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
