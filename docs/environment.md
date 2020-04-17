# 多环境配置

一般项目都会配置多个环境，比如开发环境、测试环境、生产环境等等。`Vapor` 也支持各个环境的配置。

## .env 文件

`Vapor` 默认支持 3 种环境，分别为 `production`、`development` 和 `testing`。在项目根目录下创建不同的 `.env` 文件，可表示对应环境的配置。比如：`.env.development`、`.env.testing` 和 `.env.production` 。

| 名称 | 缩写 | 描述 |
| ---- | ---- | ---- |
| production | prod | 生产环境 |
| development | dev | 开发环境 |
| testing | test | 测试环境 |

## 指定环境

通过执行如下命令可指定对应环境。

> 注意
>
> 本教程使用的是 `Vapor Toolbox Beta` 版）

* 生产环境

```shell
vapor-beta run serve --env production
```

或

```shell
vapor-beta run serve -e prod
```

* 测试环境

```shell
vapor-beta run serve --env testing
```

或

```shell
vapor-beta run serve -e test
```

* 开发环境

```shell
vapor-beta run serve --env development
```

或

```shell
vapor-beta run serve -e dev
```

另外，也可以通过代码直接指定环境。

* 代码（原始）

```swift
var env = try Environment.detect()

try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
```

* 代码（改造后）

```swift
var env = Environment(name: "testing", arguments: ["vapor"])

try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
```

## 验证

如果在 `.env` 文件中定义了一个 `Key-Value` 数据，比如 `Key` 为 `name`。

* .env.production

```
name=SwiftMic_production
```

* .env.testing

```
name=SwiftMic_testing
```

* .env.development

```
name=SwiftMic_development
```

启动时指定对应环境，就可以获取到该环境下的 `Value`。代码如下：

```swift
let nameValue = Environment.get("name")
```

## 扩展

除了 `Vapor` 默认支持的 3 种环境外，也可以按需自定义新的环境。比如新增一个 `staging` 环境，只需要创建新文件 `.env.staging` 即可。