workspace(name = 'frp_sample')
load('@bazel_tools//tools/build_defs/repo:git.bzl', 'git_repository')
load('@bazel_tools//tools/build_defs/repo:git.bzl', 'new_git_repository')
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")


http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "c84962b64d9ae4472adfb01ec2cf1aa73cb2ee8308242add55fa7cc38602d882",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/0.31.2/rules_apple.0.31.2.tar.gz",
)

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)
apple_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()


load(
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

##third_part

new_git_repository(
    name = "rxswift",
    remote = "https://github.com/ReactiveX/RxSwift.git",
    tag = "6.2.0",
    build_file_content = """
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
package(default_visibility = ["//visibility:public"])

swift_library(
    name = "RxSwift",
    srcs = glob([
        "Sources/RxSwift/**/*.swift",
    ]),
    copts = ["-no-warnings-as-errors"],
)

objc_library(
    name = "RxCocoaRuntime",
    srcs = glob([
        "Sources/RxCocoaRuntime/**/*.m",
    ]),
    hdrs = glob(["Sources/RxCocoaRuntime/include/*.h"]),
    includes = ["Sources/RxCocoaRuntime/include"],
    module_name = "RxCocoaRuntime",
)


swift_library(
    name = "RxCocoa",
    srcs = glob([
        "Sources/RxCocoa/**/*.swift",
    ]),
    copts = ["-no-warnings-as-errors"],
    defines = ["SWIFT_PACKAGE"],
    deps = [":RxSwift", ":RxRelay", ":RxCocoaRuntime"],
)

swift_library(
    name = "RxRelay",
    srcs = glob([
        "Sources/RxRelay/**/*.swift",
    ]),
    copts = ["-no-warnings-as-errors"],
    deps = [":RxSwift"],
)

""",
)

new_git_repository(
    name = "iglistkit",
    remote = "https://github.com/bilibili/IGListKit.git",
    tag = "ra4.0.0--bl0.1.0--20210113--001",
    build_file_content = """
package(default_visibility = ["//visibility:public"])

objc_library(
    name = "IGListDiffKit",
    srcs = glob([
        "Source/IGListDiffKit/**/*.m",
        "Source/IGListDiffKit/**/*.mm",
        "Source/IGListDiffKit/Internal/*.h"
    ]),
    hdrs = glob(["Source/IGListDiffKit/*.h"]),
    includes = ["Source", "Source/IGListDiffKit", "Source/IGListDiffKit/Internal"],
    module_name = "IGListDiffKit",
)

objc_library(
    name = "IGListKit",
    srcs = glob([
        "Source/IGListKit/*.m",
        "Source/IGListKit/*.mm",
        "Source/IGListKit/Internal/*.m",
        "Source/IGListKit/Internal/*.mm",
        "Source/IGListKit/Internal/*.h"
    ]),
    hdrs = glob(["Source/IGListKit/*.h"]),
    includes = ["Source", "Source/IGListKit", "Source/IGListKit/Internal"],
    deps = [":IGListDiffKit"],
    module_name = "IGListKit",
)


""",
)

new_git_repository(
    name = "stevia",
    remote = "https://github.com/freshOS/Stevia.git",
    tag = "5.1.1",
    build_file_content = """

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
package(default_visibility = ["//visibility:public"])


swift_library(
    name = "Stevia",
    srcs = glob([
        "Sources/Stevia/**/*.swift",
    ]),
    module_name = "Stevia",
)
""",
)

new_git_repository(
    name = "resolver",
    remote = "https://github.com/xinzhengzhang/Resolver.git",
    tag = "ra1.4.1--bl-1.0.0-20210428--001",
    build_file_content = """

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
package(default_visibility = ["//visibility:public"])


swift_library(
    name = "Resolver",
    srcs = glob([
        "Sources/Resolver/**/*.swift",
    ]),
    copts = ["-no-warnings-as-errors"],
    module_name = "Resolver",
)
""",
)

new_git_repository(
    name = "delegated",
    remote = "https://github.com/dreymonde/Delegated.git",
    tag = "2.1.0",
    build_file_content = """

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
package(default_visibility = ["//visibility:public"])


swift_library(
    name = "Delegated",
    srcs = glob([
        "Sources/Delegated/**/*.swift",
    ]),
    copts = ["-no-warnings-as-errors"],
    module_name = "Delegated",
)
""",
)

new_git_repository(
    name = "rxfeedback",
    remote = "https://github.com/NoTests/RxFeedback.swift.git",
    tag = "4.0.0",
    build_file_content = """

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
package(default_visibility = ["//visibility:public"])


swift_library(
    name = "RxFeedback",
    srcs = glob([
        "Sources/*.swift",
    ]),
    module_name = "RxFeedback",
)
""",
)
