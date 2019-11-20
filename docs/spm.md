# SPM

`Swift Package Manager`（简称：`SPM`）用于构建项目源码以及各种依赖。它类似于 Cocoapods、Ruby gems、和 NPM 。大多数情况下，Vapor 应用直接使用 [Vapor Toolbox](toolbox.md) 即可，toolbox 内部将会与 SPM 进行交互。不过，理解基础概念还是很重要的。

> 提示
> 
> 想了解更多关于 SPM ，可访问 [Swift.org](https://swift.org/package-manager/)

## Package Manifest

首先看下 package 配置文件。它位于项目根目录中，并被命名为 ```Package.swift``` 。

```
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Fluent"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
```

### Tools Version

第一行表示需要使用的 Swift tools 版本号，它指明了 Swift 的最低可用版本。

```
// swift-tools-version:5.1
```

### Package Name

`name` 字段代表当前 `package` 的名字。

### Platforms

`platforms` 字段代表当前支持的最低系统版本号。比如， `.macOS(.v10_15)` 表示当前支持的系统版本号是 v10.15 及以上。

### Products

`products` 字段代表 `package` 构建的时候要生成的 `targets`。示例中，有两个 targets，一个是 library，另一个是 executable 。

### Dependencies

`dependencies` 字段代表需要依赖的 SPM package。所有 Vapor 应用都依赖于 Vapor package ，但是你也可以添加其它想要的 dependency 。

上面这个示例可见，[Vapor](https://github.com/vapor/vapor) 4.0 或以上版本是这个 package 的 dependency 。当在 package 中添加了 dependency 后，接下来你必须设置 targets 。

> 提示
> 
> 只要修改了 package manifest，都需要调用 `vapor update` 来让变更内容生效。

### Targets

Targets 包含了所有的 modules、executables 以及 tests 。

```
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    ......
    targets: [
        .target(name: "App", dependencies: ["Fluent"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
```

虽然可以添加任意多的 targets 来组织代码，但大部分 Vapor 应用有 3 个 target 就足够了。每个 target 声明了它依赖的 module 。为了在代码中可以 `import` 这些 modules ，你必须添加 module 名字。一个 target 可以依赖于工程中其它的 target 或者暴露出来的 modules 。

> 提示
> 
> Executable targets (包含 `main.swift` 文件的 target) 不能被其它 modules 导入。这就是为什么 Vapor 会有 `App` 和 `Run` 两个 target。任何包含在 `App` 中的代码都可以在 `AppTests` 中被测试验证。

## 目录结构

以下是典型的 SPM package 目录结构。

```
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

第一次构建成功后，`SPM` 将会自动创建一个 `Package.resolved` 文件。`Package.resolved` 保存了当前项目所有用到的 dependency 版本。

`Package.resolved` 示例如下：

```
{
  "object": {
    "pins": [
      {
        "package": "async-http-client",
        "repositoryURL": "https://github.com/swift-server/async-http-client.git",
        "state": {
          "branch": null,
          "revision": "51dc885a30ca704b02fa803099b0a9b5b38067b6",
          "version": "1.0.0"
        }
      },
      {
        "package": "async-kit",
        "repositoryURL": "https://github.com/vapor/async-kit.git",
        "state": {
          "branch": null,
          "revision": "d9fd2be441af6d1428b62ab694848396e7072a14",
          "version": "1.0.0-beta.1"
        }
      },
      ......
    ]
  },
  "version": 1
}
```

## 遇到问题

如果你遇到 SPM 相关的问题，可以尝试 clean 下工程项目试试。

```
vapor clean
```