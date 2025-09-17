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
			name: "MUSE.Primitives",
			targets: ["Numerics", "Dense", "Sparse"]
		),
		.library(
			name: "MUSE.Essentials",
			targets: ["Layout", "Optimise"]
		),
    ],
	dependencies: [
		.package(url: "https://github.com/ars-tools/MUCE", branch: "release")
	],
    targets: [
		.target(
			name: "Dense",
			dependencies: ["Layout", "Numerics"],
			path: "Dense/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "DenseTests",
			dependencies: ["Dense"],
			path: "Dense/Tests"
		),
		.target(
			name: "Sparse",
			dependencies: ["Dense", .productItem(name: "MUCE.Auxiliary", package: "MUCE", moduleAliases: .none, condition: .none)],
			path: "Sparse/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "SparseTests",
			dependencies: ["Sparse"],
			path: "Sparse/Tests"
		),
		.target(
			name: "Optimise",
			dependencies: ["Dense", "Sparse"],
			path: "Optimise/Sources"
		),
		.testTarget(
			name: "OptimiseTests",
			dependencies: ["Optimise"],
			path: "Optimise/Tests"
		),
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
			name: "LayoutTests",
			dependencies: ["Layout"],
			path: "Layout/Tests"
		),
    ]
)
