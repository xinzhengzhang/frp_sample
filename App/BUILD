load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load(
    "@build_bazel_rules_apple//apple:versioning.bzl",
    "apple_bundle_version",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

licenses(["notice"])

filegroup(
    name = "PhoneAppIcon.xcassets",
    srcs = glob(["PhoneAppIcon.xcassets/**"]),
)

exports_files([
    "Launch.storyboard",
])

swift_library(
    name = "Sources",
    srcs = [
        "Sources/AppDelegate.swift",
    ],
    data = [
        "Resources/Main.storyboard",
    ],
)

apple_bundle_version(
    name = "HelloWorldVersion",
    build_version = "1.0",
)

ios_application(
    name = "app",
    app_icons = [":PhoneAppIcon.xcassets"],
    bundle_id = "moe.zxz.frp.sample",
    families = [
        "iphone",
    ],
    infoplists = [":Info.plist"],
    launch_storyboard = ":Launch.storyboard",
    minimum_os_version = "9.0",
    version = ":HelloWorldVersion",
    deps = [":Sources"],
)