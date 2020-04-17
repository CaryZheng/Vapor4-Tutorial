import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    
    let nameValue = Environment.get("name")
    print("Current env = \(app.environment)")
    print("env key: name, value: \(String(describing: nameValue))")
    
    switch app.environment {
    case .production:
        print("production")
    case .testing:
        print("testing")
    case .development:
        print("development")
    case .custom(name: "staging"):
        print("staging")
    default:
        print("other")
    }
    
    try routes(app)
}
