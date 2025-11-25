// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Rikka",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "Rikka",
      targets: ["Rikka"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.11.2")
  ],
  targets: [
    .target(
      name: "Rikka",
      dependencies: ["SwiftSoup"]
    )
  ]
)
