//
//  UserController.swift
//  App
//
//  Created by Cary on 2019/11/19.
//

import Vapor
import Fluent

class UserController {
    
    func createUser(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
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
}
