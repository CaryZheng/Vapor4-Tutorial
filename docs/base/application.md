# Application

`Application` 是 Vapor 中一个非常重要的类，负责管理各类基础组件（比如：Provider、Middleware、Database、Route 等等）。

`Application` 的部分源码如下

```
public final class Application {
    public var environment: Environment
    public var services: Services
    public let sync: Lock
    public var userInfo: [AnyHashable: Any]
    public private(set) var didShutdown: Bool
    internal let eventLoopGroup: EventLoopGroup
    public var logger: Logger
    private var isBooted: Bool

    public var providers: [Provider] {
        return self.services.providers
    }
    
    public init(environment: Environment = .development) {
        self.environment = environment
        self.services = .init()
        self.sync = .init()
        self.userInfo = [:]
        self.didShutdown = false
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        self.logger = .init(label: "codes.vapor.application")
        self.isBooted = false
        self.registerDefaultServices()
    }

    ......
}

extension Application: RoutesBuilder {
    public func add(_ route: Route) {
        self.routes.add(route)
    }
    
    public var routes: Routes {
        return self.make()
    }
}
```

其中

* `environment`：主要用于存放程序当前运行环境相关的数据。
* `providers`：主要用于管理各种类型的 `Provider` 。
* `services`：主要用于管理各种类型的服务组件。
* `routes`：主要用于管理 API 路由。

接下来，我们来看下 `App` 目录下的 `configure.swift` 文件。

```
// Called before your application initializes.
func configure(_ app: Application) throws {
    // Register providers first
    app.provider(FluentProvider())

    // Register middleware
    app.register(extension: MiddlewareConfiguration.self) { middlewares, app in
        // Serves files from `Public/` directory
        middlewares.use(app.make(FileMiddleware.self))
    }
    
    app.databases.sqlite(
        configuration: .init(storage: .connection(.file(path: "db.sqlite"))),
        threadPool: app.make(),
        poolConfiguration: app.make(),
        logger: app.make(),
        on: app.make()
    )
    
    app.register(Migrations.self) { c in
        var migrations = Migrations()
        migrations.add(CreateTodo(), to: .sqlite)
        return migrations
    }
    
    try routes(app)
}
```

还有 `routes.swift` 文件。

```
func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.on(.DELETE, "todos", ":todoID", use: todoController.delete)
}
```

从中可以看出来，`Application` 管理着各类基础组件（比如：Provider、Middleware、Database、Route 等等），并贯穿于程序的整个生命周期。