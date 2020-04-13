import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }
    
    let userController = UserController()
    app.post("user", use: userController.create)
//    app.get("user", "all", use: userController.fetchAll)
    app.get(["user", "all"], use: userController.fetchAll)
    app.get("user", ":userId", use: userController.fetch)
    app.on(.DELETE, "user", ":userId", use: userController.delete)
}
