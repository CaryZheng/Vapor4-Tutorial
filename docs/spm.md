# SPM

`Swift Package Manager`（简称：`SPM`）用于构建项目源码以及各种依赖。它类似于 `Cocoapods`、`Ruby gems`、和 `NPM` 。大多数情况下，`Vapor` 应用直接使用 `Vapor Toolbox` 即可，`toolbox` 内部将会与 `SPM` 进行交互。不过，理解基础概念还是很重要的。

> 提示
> 
> 想了解更多关于 SPM ，可访问 [Swift.org](https://swift.org/package-manager/)

## Package Manifest

首先看下 `package` 配置文件。它位于项目根目录中，并被命名为 ```Package.swift``` 。

```swift
// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "ExampleHello",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
```

### Tools Version

第一行表示当前使用的 `swift tools` 版本号。

```swift
// swift-tools-version:5.6
```

### Package Name

`name` 字段代表当前 `package` 的名字。

### Platforms

`platforms` 字段代表当前支持的最低系统版本号。比如， `.macOS(.v12)` 表示当前支持的系统版本号是 `v12` 及以上。

### Dependencies

`dependencies` 字段代表需要依赖的 `SPM` `package`。所有 `Vapor` 应用都依赖于 `Vapor` `package` ，当然你也可以添加其它想要的 `dependency` 。

上面这个示例可见，[Vapor](https://github.com/vapor/vapor) `4.0+` 版本是这个 `package` 的 `dependency` 。

> 提示
> 
> 只要修改了 package manifest，都需要调用 `vapor update` 来让变更内容生效。

### Targets

`Targets` 包含了 `target`、`executableTarget` 以及 `testTarget` 。

```swift
// swift-tools-version:5.6
import PackageDescription

let package = Package(
    ......
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
```

示例中，`App` 这个 `target` 里包含了 `Fluent`、`FluentSQLiteDriver` 以及 `Vapor` 这些依赖项。

> 提示
> 
> `executableTarget` (包含 `main.swift` 文件的 target) 不能被其它 `module` 导入。这就是为什么 `Vapor` 会有 `App` 和 `Run` 两种 target。任何包含在 `App` 中的代码都可以在 `AppTests` 中被测试验证。

## 目录结构

以下是典型的 SPM package 目录结构。

```shell
.
├── Sources
│   ├── App
│   │   └── (Source code)
│   └── Run
│       └── main.swift
├── Tests
│   └── AppTests
└── Package.swift
```

每个 `.target` 对应 `Sources` 中的一个文件夹。每个 `.testTarget` 对应 `Tests` 中的一个文件夹。

## Package.resolved

第一次构建成功后，`SPM` 将会自动创建一个 `Package.resolved` 文件。`Package.resolved` 保存了当前项目所有用到的 `dependency` 版本，这样以后每次 `Build` 都将使用相同的版本号。

`Package.resolved` 示例如下：

```shell
{
  "pins" : [
    {
      "identity" : "async-http-client",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/swift-server/async-http-client.git",
      "state" : {
        "revision" : "7a4dfe026f6ee0f8ad741b58df74c60af296365d",
        "version" : "1.9.0"
      }
    },
    {
      "identity" : "async-kit",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/vapor/async-kit.git",
      "state" : {
        "revision" : "e2f741640364c1d271405da637029ea6a33f754e",
        "version" : "1.11.1"
      }
    },
    ......
  ],
  "version" : 2
}
```

> 提示
> 
>  如果想更新 `dependency` 版本，可执行 `swift package update` 。

## 遇到问题

如果你遇到 `SPM` 相关的问题，可以尝试 `clean` 下工程项目试试。

```shell
vapor clean
```