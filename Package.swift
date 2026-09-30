// swift-tools-version:5.9
//
// Swift Package Manager manifest for TunnelKit.
//
// Sources stay in their original locations so the Xcode project and the
// podspec keep working. Because SwiftPM does not allow mixing Swift and
// Objective-C in one target, the code is split into:
//
// - `__TunnelKitCore`     Objective-C part of Core (same name as the existing modulemap)
// - `__TunnelKitOpenVPN`  Objective-C part of OpenVPN (same name as the existing modulemap)
// - `__TunnelKitLZO`      optional LZO compression (loaded at runtime by class name)
// - `TunnelKit`           all Swift sources (Core, AppExtension, Manager, OpenVPN)
//
// Consumers keep writing `import TunnelKit`, exactly as with CocoaPods.

import PackageDescription

let package = Package(
    name: "TunnelKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "TunnelKit",
            targets: ["TunnelKit"]
        ),
        .library(
            name: "TunnelKitLZO",
            targets: ["__TunnelKitLZO"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: "1.9.5")
    ],
    targets: [
        .binaryTarget(
            name: "openssl",
            path: "openssl.xcframework"
        ),
        .target(
            name: "__TunnelKitCore",
            path: "TunnelKit/Sources/Core",
            sources: [
                "Allocation.m",
                "DNS.m",
                "Errors.m",
                "LZO.m",
                "RoutingTable.m",
                "RoutingTableEntry.m",
                "ZeroingData.m"
            ],
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedLibrary("resolv")
            ]
        ),
        .target(
            name: "__TunnelKitOpenVPN",
            dependencies: [
                "__TunnelKitCore",
                "openssl"
            ],
            path: "TunnelKit/Sources/Protocols/OpenVPN",
            sources: [
                "ControlPacket.m",
                "CryptoAEAD.m",
                "CryptoBox.m",
                "CryptoCBC.m",
                "CryptoCTR.m",
                "DataPath.m",
                "MSS.m",
                "PacketMacros.m",
                "PacketStream.m",
                "ReplayProtector.m",
                "TLSBox.m"
            ],
            publicHeadersPath: "."
        ),
        .target(
            name: "__TunnelKitLZO",
            dependencies: [
                "__TunnelKitCore"
            ],
            path: "TunnelKit/Sources/Extra/LZO",
            exclude: [
                "lib/COPYING",
                "lib/Makefile",
                "lib/README.LZO",
                "lib/testmini.c"
            ],
            sources: [
                "StandardLZO.m",
                "lib/minilzo.c"
            ],
            publicHeadersPath: "lib"
        ),
        .target(
            name: "TunnelKit",
            dependencies: [
                "__TunnelKitCore",
                "__TunnelKitOpenVPN",
                "SwiftyBeaver"
            ],
            path: "TunnelKit/Sources",
            exclude: [
                "Extra",

                "Core/module.modulemap",
                "Core/Allocation.h",
                "Core/Allocation.m",
                "Core/DNS.h",
                "Core/DNS.m",
                "Core/Errors.h",
                "Core/Errors.m",
                "Core/LZO.h",
                "Core/LZO.m",
                "Core/route.h",
                "Core/RoutingTable.h",
                "Core/RoutingTable.m",
                "Core/RoutingTableEntry.h",
                "Core/RoutingTableEntry.m",
                "Core/ZeroingData.h",
                "Core/ZeroingData.m",

                "Protocols/OpenVPN/module.modulemap",
                "Protocols/OpenVPN/CompressionAlgorithmNative.h",
                "Protocols/OpenVPN/CompressionFramingNative.h",
                "Protocols/OpenVPN/ControlPacket.h",
                "Protocols/OpenVPN/ControlPacket.m",
                "Protocols/OpenVPN/Crypto.h",
                "Protocols/OpenVPN/CryptoAEAD.h",
                "Protocols/OpenVPN/CryptoAEAD.m",
                "Protocols/OpenVPN/CryptoBox.h",
                "Protocols/OpenVPN/CryptoBox.m",
                "Protocols/OpenVPN/CryptoCBC.h",
                "Protocols/OpenVPN/CryptoCBC.m",
                "Protocols/OpenVPN/CryptoCTR.h",
                "Protocols/OpenVPN/CryptoCTR.m",
                "Protocols/OpenVPN/CryptoMacros.h",
                "Protocols/OpenVPN/DataPath.h",
                "Protocols/OpenVPN/DataPath.m",
                "Protocols/OpenVPN/DataPathCrypto.h",
                "Protocols/OpenVPN/MSS.h",
                "Protocols/OpenVPN/MSS.m",
                "Protocols/OpenVPN/PacketMacros.h",
                "Protocols/OpenVPN/PacketMacros.m",
                "Protocols/OpenVPN/PacketStream.h",
                "Protocols/OpenVPN/PacketStream.m",
                "Protocols/OpenVPN/ReplayProtector.h",
                "Protocols/OpenVPN/ReplayProtector.m",
                "Protocols/OpenVPN/TLSBox.h",
                "Protocols/OpenVPN/TLSBox.m"
            ],
            linkerSettings: [
                .linkedFramework("NetworkExtension")
            ]
        ),
        .testTarget(
            name: "TunnelKitTests",
            dependencies: [
                "TunnelKit",
                "__TunnelKitLZO"
            ],
            path: "TunnelKit/Tests",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("pia-2048.pem"),
                .copy("pia-hungary.ovpn"),
                .copy("tunnelbear.crt"),
                .copy("tunnelbear.enc.1.key"),
                .copy("tunnelbear.enc.1.ovpn"),
                .copy("tunnelbear.enc.8.key"),
                .copy("tunnelbear.enc.8.ovpn"),
                .copy("tunnelbear.key")
            ]
        )
    ]
)
