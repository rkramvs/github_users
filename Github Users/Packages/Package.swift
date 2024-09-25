// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "GitHubRequest", targets: ["APIKit", "GitHubRequest"])
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "APIKit",
            dependencies: [],
            path: "APIKit"),
        .target(
            name: "GitHubRequest",
            dependencies: ["APIKit"],
            path: "GitHubRequest"),
    ]
)
