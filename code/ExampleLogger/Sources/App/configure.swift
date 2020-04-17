import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    try routes(app)
}
