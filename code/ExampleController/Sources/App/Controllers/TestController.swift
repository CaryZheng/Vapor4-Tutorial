import Vapor

struct TestController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let routeBuilder = routes.grouped("test")
        
        // 请求路径：test，参数：<userId>, 请求方法: GET，响应方法：findUser。
        routeBuilder.get(":userId", use: findUser)
        
        // 请求路径：test，请求方法: POST，响应方法：createUser。
        routeBuilder.post(use: createUser)
        
        // 请求路径：test，请求方法: PUT，响应方法：updateUser。
        routeBuilder.put(use: updateUser)
        
        // 请求路径：test，参数：<userId>, 请求方法: DELETE，响应方法：deleteUser。
        routeBuilder.delete(":userId", use: deleteUser)
    }
    
    func createUser(req: Request) -> String {
        return "Create SwiftMic test user"
    }

    func updateUser(req: Request) -> String {
        return "Update SwiftMic test user"
    }

    func findUser(req: Request) -> String {
        let userId = req.parameters.get("userId")
        if nil == userId || userId!.isEmpty {
            return "Require param: userId"
        }

        return "Find SwiftMic test user: " + userId!
    }

    func deleteUser(req: Request) -> String {
        let userId = req.parameters.get("userId")
        if nil == userId || userId!.isEmpty {
            return "Require param: userId"
        }

        return "Delete SwiftMic test user: " + userId!
    }
}
