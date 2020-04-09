import Vapor

struct UserResponse: Content {
    var id: Int
    var username: String
}
