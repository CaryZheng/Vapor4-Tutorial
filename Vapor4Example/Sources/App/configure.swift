import Fluent
import FluentMySQLDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // config MySQL
    app.databases.use(.mysql(hostname: "127.0.0.1", port: 3306, username: "root", password: "YourPassword", database: "swift_mic_test", tlsConfiguration: nil), as: .mysql)
    
    // Add middleware
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(MyMiddleware())
    
    try routes(app)
}
