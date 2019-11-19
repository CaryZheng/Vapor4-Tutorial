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
    
    let userController = UserController()
    app.post("user", use: userController.createUser)
    app.get("user", ":userId", use: userController.findUser)
    app.put("user", use: userController.updateUser)
    app.delete("user", ":userId", use: userController.deleteUser)
    
    let testController = TestController()
    app.post("test", use: testController.createUser)
    app.put("test", use: testController.updateUser)
    app.get("test", ":userId", use: testController.findUser)
    app.delete("test", ":userId", use: testController.deleteUser)
    
    // 路由组
    app.group("v1") { builder in
        
        // 此处定义的所有请求路径都是在路由组（"v1"）下面的。
        builder.get("name") { req in
            return "Request path: v1/name"
        }
        
        builder.get("avatar") { req in
            return "Request path: v1/avatar"
        }
    }
}
