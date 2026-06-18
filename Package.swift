// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "MUSE",
	platforms: [
		.iOS(.v26),
		.tvOS(.v26),
		.macCatalyst(.v26),
        .macOS(.v26),
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
        .library(
            name: "MUSE.Headers",
            targets: ["AMX"]
        ),
    ],
	dependencies: [
		.package(url: "https://github.com/ars-tools/MUCE", branch: "release")
	],
    targets: [
		.target(
			name: "Dense",
			dependencies: ["Layout", "Numerics", "AMX"],
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
            name: "AMX",
            path: "AMX/Sources",
            publicHeadersPath: ".",
            cSettings: [
                .define("ACCELERATE_NEW_LAPACK"),
                .define("ACCELERATE_LAPACK_ILP64")
            ]
        ),
        .testTarget(
            name: "AMXTests",
            dependencies: [
                "AMX"
            ],
            path: "AMX/Tests",
            cSettings: [
                .define("ACCELERATE_NEW_LAPACK"),
                .define("ACCELERATE_LAPACK_ILP64")
            ]
        ),
		.target(
			name: "Numerics",
            dependencies: [
                "AMX"
            ],
			path: "Numerics/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "NumericsTests",
			dependencies: ["Numerics"],
			path: "Numerics/Tests",
            cSettings: [
                .define("ACCELERATE_NEW_LAPACK"),
                .define("ACCELERATE_LAPACK_ILP64")
            ]
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
