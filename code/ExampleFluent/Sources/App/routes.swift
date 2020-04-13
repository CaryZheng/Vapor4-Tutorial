import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }
    
    let userController = UserController()
    app.post("user", use: userController.create)
//    app.get("user", "all", use: userController.fetchAll)
    app.get(["user", "all"], use: userController.fetchAll)
    app.get("user", ":userId", use: userController.fetch)
    app.on(.DELETE, "user", ":userId", use: userController.delete)
    
    let articleController = ArticleController()
    app.post("article", use: articleController.createArticle)
    app.get("article", ":articleId", use: articleController.fetchArticleDetail)
    app.get("user", "article", ":userId" , use: articleController.fetchUserArticleList)
    app.on(.DELETE, "article", ":articleId", use: articleController.delete)
}
