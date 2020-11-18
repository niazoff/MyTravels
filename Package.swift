// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "MyTravels",
    products: [
        .executable(
            name: "MyTravels",
            targets: ["MyTravels"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
      .target(
          name: "MyTravels",
          dependencies: ["Publish"]
      )
    ]
)
