import Fluent
import Vapor
import MySQLKit

struct UserController {
    /// 查询所有用户信息
    func fetchAll(req: Request) throws -> EventLoopFuture<String> {
        return User.query(on: req.db).all().map { userList in
            return ResponseWrapper(protocolCode: .success, obj: userList).makeResponse()
        }
    }
    
    /// 查询某个用户信息
    func fetch(req: Request) throws -> EventLoopFuture<String> {
        guard let userId = req.parameters.get("userId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        return User.find(userId, on: req.db).map { user -> String in
            guard let user = user else {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeResponse()
            }
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
    }

    /// 创建用户
    func create(req: Request) throws -> EventLoopFuture<String> {
        let user = try req.content.decode(User.self)
        
        return user.save(on: req.db).map {
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
    }

    /// 删除用户
    func delete(req: Request) throws -> EventLoopFuture<String> {
        guard let userId = req.parameters.get("userId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        let user = User()
        user.id = userId
        return user.delete(on: req.db).map {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
        }
    }
    
    /// 查询前10个用户信息
    func fetchUserTop10(req: Request) throws -> EventLoopFuture<String> {
        let sql = """
            SELECT * FROM user LIMIT 10;
        """
        return (req.db as! MySQLDatabase).sql().raw(SQLQueryString(sql)).all(decoding: User.self).map { users in
            return ResponseWrapper(protocolCode: .success, obj: users).makeResponse()
        }
    }
}
