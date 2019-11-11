//
//  MyMiddleware.swift
//  App
//
//  Created by Cary on 2019/11/11.
//

import Vapor

public final class MyMiddleware: Middleware {
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        // Handle request before
        // ......
        
        // Handle request
        let resposneFuture = next.respond(to: request)
        
        // Handle request after
        return resposneFuture.flatMap { response in
            response.headers.add(name: "My-Key", value: "Test123456")
            
            return request.eventLoop.makeSucceededFuture(response)
        }
    }
}
