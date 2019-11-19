import Fluent
//import FluentSQLiteDriver
import FluentMySQLDriver
import Vapor

// Called before your application initializes.
func configure(_ app: Application) throws {
    // Register providers first
    app.provider(FluentProvider())

    app.register(MyMiddleware.self) { app in
        return MyMiddleware()
    }
    
    // Register middleware
    app.register(extension: MiddlewareConfiguration.self) { middlewares, app in
        // Serves files from `Public/` directory
        middlewares.use(app.make(FileMiddleware.self))
        
        middlewares.use(app.make(MyMiddleware.self))
    }
    
//    app.databases.sqlite(
//        configuration: .init(storage: .connection(.file(path: "db.sqlite"))),
//        threadPool: app.make(),
//        poolConfiguration: app.make(),
//        logger: app.make(),
//        on: app.make()
//    )
    
//    app.register(Migrations.self) { c in
//        var migrations = Migrations()
//        migrations.add(CreateTodo(), to: .sqlite)
//        return migrations
//    }
    
    let mysqlConfig = MySQLConfiguration(hostname: "127.0.0.1", port: 3306, username: "root", password: "xxxxxxxx", database: "swift_mic_test", tlsConfiguration: nil)
    app.databases.mysql(configuration: mysqlConfig, on: app.make())
    
    app.register(Migrations.self) { c in
        var migrations = Migrations()
        migrations.add(CreateTodo(), to: .mysql)
        return migrations
    }
    
    try routes(app)
}
