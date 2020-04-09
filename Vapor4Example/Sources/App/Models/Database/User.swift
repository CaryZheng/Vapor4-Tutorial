//
//  User.swift
//  App
//
//  Created by Cary on 2019/11/19.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "user"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "username")
    var username: String

    init() {}

    init(id: Int? = nil, username: String) {
        self.id = id
        self.username = username
    }
}
