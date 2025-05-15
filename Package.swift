// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MUSE",
	platforms: [
		.iOS(.v18),
		.tvOS(.v18),
		.macCatalyst(.v18),
		.macOS(.v15),
	],
    products: [
        .library(
            name: "MUSE",
            targets: ["Numerics", "Layout"]
		),
    ],
    targets: [
		.target(
			name: "Numerics",
			path: "Numerics/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "NumericsTests",
			dependencies: ["Numerics"],
			path: "Numerics/Tests"
		),
		.target(
			name: "Layout",
			path: "Layout/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "Layout",
			dependencies: ["Layout"],
			path: "Layout/Tests"
		)
    ]
)
