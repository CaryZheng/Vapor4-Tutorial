# 日志

`Vapor` 的日志 API 是基于 [SwiftLog](https://github.com/apple/swift-log) 构建的，意味着 `SwiftLog` 所有特性 `Vapor` 也都是支持的。

## 日志等级

| 名称 | 描述 |
| --- | --- |
| trace | Appropriate for messages that contain information only when debugging a program. |
| debug | Appropriate for messages that contain information normally of use only when debugging a program. |
| info | Appropriate for informational messages. |
| notice |  Appropriate for conditions that are not error conditions, but that may require special handling. |
| warning | Appropriate for messages that are not error conditions, but more severe than notice. |
| error | Appropriate for error conditions. |
| critical | Appropriate for critical error conditions that usually require immediate attention. |

> 提示
> 
> 日志等级依次由低到高排列：`trace` < `debug` < `info` < `notice` < `warning` < `error` < `critical`

## Request

每一个 `Request` 都有一个唯一的日志 `ID`。以下面代码为例：

```swift
app.get("hello") { req -> String in
    req.logger.trace("hello log trace")
    req.logger.debug("hello log debug")
    req.logger.info("hello log info")
    req.logger.notice("hello log notice")
    req.logger.warning("hello log warning")
    req.logger.error("hello log error")
    req.logger.critical("hello log critical")
    
    return "Hello, world!"
}
```

执行 `vapor-beta run serve --log trace` 命令。

```shell
[ NOTICE ] Server starting on http://127.0.0.1:8080 (Vapor/HTTP/Server/HTTPServer.swift:183)
[ INFO ] GET /hello [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (Vapor/Responder/DefaultResponder.swift:39)
[ DEBUG ] hello log debug [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:10)
[ INFO ] hello log info [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:11)
[ NOTICE ] hello log notice [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:12)
[ WARNING ] hello log warning [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:13)
[ ERROR ] hello log error [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:14)
[ CRITICAL ] hello log critical [request-id: BC249D72-CFD0-40F9-A2B9-D213EFEBC565] (App/routes.swift:15)
```

程序将会输出 `trace` 及以上等级的日志信息。其中，同一个 `Request`，对应的 `request-id` 也是一样的。

> 提示
> 
> `request-id` 以及所在文件行数只在 `trace` 和 `debug` 等级下才会输出。

如果执行 `vapor-beta run serve --log notice` 命令，将只输出 `notice` 及以上的日志信息，`debug` 和 `trace` 等级的日志将会被过滤掉。

```swift
[ NOTICE ] hello log notice
[ WARNING ] hello log warning
[ ERROR ] hello log error
[ CRITICAL ] hello log critical
```

## Application

也可以通过 `Application`  来使用 `logger`。

```swift
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

app.logger.info("Start to config")

try configure(app)
try app.run()
```

启动程序后，如果使用的日志等级是 `info` 及以下的话，将显示如下信息：

```shell
[ INFO ] Start to config
```

## 自定义 Logger

某些场景下可能无法直接访问到 `Request` 和 `Application` 实例，此时可以自定义 `Logger`。

```swift
let myLogger = Logger(label: "com.swiftmic.logger")
myLogger.info("This is message from myLogger")
```

## 自定义 Handler

可以覆写 `Vapor` 默认的日志 handler，改成使用我们自己的。

```swift
LoggingSystem.bootstrap { label in
    StreamLogHandler.standardOutput(label: label)
}
```