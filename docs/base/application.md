# Application

`Application` 是 Vapor 中一个非常重要的类，负责管理各类基础组件（比如：Provider、Middleware、Database、Route 等等）。

`Application` 的部分源码如下

``` swift
public final class Application {
    public var environment: Environment
    public let eventLoopGroupProvider: EventLoopGroupProvider
    public let eventLoopGroup: EventLoopGroup
    public var storage: Storage
    public private(set) var didShutdown: Bool
    public var logger: Logger
    private var isBooted: Bool
    
    public init(
        _ environment: Environment = .development,
        _ eventLoopGroupProvider: EventLoopGroupProvider = .createNew
    ) {
        Backtrace.install()
        self.environment = environment
        self.eventLoopGroupProvider = eventLoopGroupProvider
        switch eventLoopGroupProvider {
        case .shared(let group):
            self.eventLoopGroup = group
        case .createNew:
            self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        }
        self.locks = .init()
        self.didShutdown = false
        self.logger = .init(label: "codes.vapor.application")
        self.storage = .init(logger: self.logger)
        self.lifecycle = .init()
        self.isBooted = false
        self.core.initialize()
        self.views.initialize()
        self.sessions.initialize()
        self.sessions.use(.memory)
        self.responder.initialize()
        self.responder.use(.default)
        self.commands.use(self.server.command, as: "serve", isDefault: true)
        self.commands.use(RoutesCommand(), as: "routes")
        // Load specific .env first since values are not overridden.
        self.loadDotEnv(named: ".env.\(self.environment.name)")
        self.loadDotEnv(named: ".env")
    }

    ......
}

extension Application: RoutesBuilder {
    public func add(_ route: Route) {
        self.routes.add(route)
    }
}
```

其中

* `environment`：主要用于存放程序当前运行环境相关的数据。
* `routes`：主要用于管理 API 路由。

接下来，我们来看下 `Run` 目录中的 `main.swift` 文件。

``` swift
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
```

还有 `configure.swift` 文件。

``` swift
// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Configure migrations
    app.migrations.add(CreateTodo())
    
    try routes(app)
}
```

最后是 `routes.swift` 文件。

``` swift
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

从中可以看出，`Application` 管理着各类基础组件（比如：Environment、Logger、Route 等等），并贯穿于程序的整个生命周期。