import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    
    let nameValue = Environment.get("name")
    print("Current env = \(app.environment)")
    print("env key: name, value: \(String(describing: nameValue))")
    
    try routes(app)
}
