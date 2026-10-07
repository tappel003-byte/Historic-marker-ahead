// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HistoricMarkerCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "HistoricMarkerCore", targets: ["HistoricMarkerCore"]),
    ],
    targets: [
        .target(
            name: "HistoricMarkerCore",
            path: "Sources/HistoricMarkerCore"
        ),
        .testTarget(
            name: "HistoricMarkerCoreTests",
            dependencies: ["HistoricMarkerCore"],
            path: "Tests/HistoricMarkerCoreTests"
        ),
    ]
)
