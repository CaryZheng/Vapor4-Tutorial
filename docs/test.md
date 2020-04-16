# 测试

`Vapor` 包含了一个测试模块 `XCTVapor`，该测试模块是基于 `XCTest` 构建的，可用于模拟 HTTP 请求进行测试。

## 开始

编辑 `Package.swift` 文件。

```swift
let package = Package(
    ......
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        ......
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
```

所有测试用例均存放于 `Tests` -> `AppTest` 目录中，默认会生成 `AppTests.swift` 文件。

导入 `XCTVapor ` 模块，然后创建一个继承于 `XCTestCase` 的 `class`（这里命名为 `AppTests`）。

```swift
import XCTVapor

final class AppTests: XCTestCase {
    func testStub() throws {
    	
    }
}
```

每个 `function` 需要以 `test` 作为前缀来命名，这样执行测试的时候会自动覆盖到这些 `function` 。

## 执行测试

* 在 `Xcode` 中，输入快捷键 `cmd+u` 即可。
* 命令行界面中，执行 `swift test --enable-test-discovery` 命令即可。

## 示例

初始化一个 `.testing` 测试环境的 `Application` 实例，并通过调用 `configure` 方法进行相关配置。

```swift
let app = Application(.testing)
defer { app.shutdown() }
try configure(app)
```

模拟一个 `HTTP` 请求测试 `hello` 接口。

`hello` 接口定义如下：

```swift
app.get("hello") { req in
    return "Hello, world!"
}
```

测试代码如下：

```swift
try app.test(.GET, "hello") { res in
    XCTAssertEqual(res.status, .ok)
    XCTAssertEqual(res.body.string, "Hello, world!")
}
```

第一个参数表示 `HTTP` Method，第二个参数表示 API 请求路径，结尾闭包中是对 `response` 的处理，并通过 `XCTAssert` 方法进行验证。

对于更复杂的 `request`，可以通过 `beforeRequest` 闭包来修改 `header` 和 `body` 内容。`response` 也有类似的操作。

示例代码如下：

```swift
try app.test(.GET, "todos") { res in
    XCTAssertContent([Todo].self, res) {
        XCTAssertEqual($0.count, 0)
    }
}.test(.POST, "todos", beforeRequest: { req in
    try req.content.encode(Todo(title: "Test My App"))
}, afterResponse:  { res in
    XCTAssertContent(Todo.self, res) {
        XCTAssertNotNil($0.id)
        XCTAssertEqual($0.title, "Test My App")
    }
}).test(.GET, "todos") { res in
    XCTAssertContent([Todo].self, res) {
        XCTAssertEqual($0.count, 1)
    }
}
```

## 补充

`Vapor` testing API 支持两种方式发送用于测试的 `request`，一种是通过内部模拟直接响应 ```respond```，另一种是通过一个 HTTP Server 来测试。

```swift
app.testable(method: .inMemory).test(...)

// Run tests through a live HTTP server.
app.testable(method: .running).test(...)
```

默认是 `inMemory` 方式，`running` 方式默认使用的是 `8080` 端口，不过也支持指定特定端口号。

```
.running(port: 8090)
```
