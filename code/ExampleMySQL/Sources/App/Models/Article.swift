import Fluent
import Vapor

final class Article: Model, Content {
    static let schema = "article"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "authorId")
    var authorId: Int
    
    @Field(key: "cover")
    var cover: String?

    init() {}

    init(id: Int? = nil, title: String, content: String, authorId: Int, cover: String?) {
        self.id = id
        self.title = title
        self.content = content
        self.authorId = authorId
        self.cover = cover
    }
}

