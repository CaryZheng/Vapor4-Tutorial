import Fluent
import FluentMySQLDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure MySQL database
    app.databases.use(.mysql(hostname: "127.0.0.1", port: 3306, username: "YourName", password: "YourPassword", database: "swift_fluent_test", tlsConfiguration: nil), as: .mysql)
    
    try routes(app)
}
