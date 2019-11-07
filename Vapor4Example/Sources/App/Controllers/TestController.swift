//
//  TestController.swift
//  App
//
//  Created by Cary on 2019/11/7.
//

import Vapor

struct TestController {
    
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
