// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Ruth",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "RuthApp", targets: ["Ruth"])
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlc-llm.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "Ruth",
            dependencies: [
                .product(name: "MLCSwift", package: "mlc-llm")
            ],
            path: "Sources/Ruth"
        )
    ]
)
