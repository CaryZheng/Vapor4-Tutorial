import Fluent
import Vapor

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
    
    let testController = TestController()
    app.post("test", use: testController.createUser)
    app.put("test", use: testController.updateUser)
    app.get("test", ":userId", use: testController.findUser)
    app.delete("test", ":userId", use: testController.deleteUser)
}
