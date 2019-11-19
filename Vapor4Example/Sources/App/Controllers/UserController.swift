//
//  UserController.swift
//  App
//
//  Created by Cary on 2019/11/19.
//

import Vapor
import Fluent

class UserController {
    
    /// 创建用户
    func createUser(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
    /// 查找用户
    func findUser(req: Request) -> EventLoopFuture<String> {
        let userId = req.parameters.get("userId") as Int?
        
        // 参数错误
        if nil == userId {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        return User.find(userId!, on: req.db).map { user -> String in
            guard let user = user else {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeResponse()
            }
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
    }
    
    /// 更新用户
    func updateUser(req: Request) throws -> EventLoopFuture<String> {
        let user = try req.content.decode(User.self)
        let username = user.username
        
        return User.find(user.id!, on: req.db).flatMap { newUser -> EventLoopFuture<String> in
            if nil == newUser {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeFutureResponse(req: req)
            }
            
            newUser!.username = username
            return newUser!.update(on: req.db).map {
                return ResponseWrapper(protocolCode: .success, obj: newUser!).makeResponse()
            }
        }
    }
    
    /// 删除用户
    func deleteUser(req: Request) -> EventLoopFuture<String> {
        let userId = req.parameters.get("userId") as Int?
        
        // 参数错误
        if nil == userId {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        let user = User()
        user.id = userId
        return user.delete(on: req.db).map {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
        }
    }
}
