import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String
    
    @Field(key: "address")
    var address: String?

    init() {}

    init(id: Int? = nil, title: String, address: String?) {
        self.id = id
        self.name = title
        self.address = address
    }
}

