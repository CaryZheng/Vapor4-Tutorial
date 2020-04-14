import Fluent
import Vapor

struct ArticleController {
    
    struct ArticleUser: Content {
        var user: User
        var article: Article
    }
    
    /// 发布文章
    func createArticle(req: Request) throws -> EventLoopFuture<String> {
        let article = try req.content.decode(Article.self)
        
        return article.create(on: req.db).map {
            return ResponseWrapper(protocolCode: .success, obj: article).makeResponse()
        }
    }
    
    /// 查询文章详情
    func fetchArticleDetail(req: Request) throws -> EventLoopFuture<String> {
        guard let articleId = req.parameters.get("articleId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
                        
        return Article.find(articleId, on: req.db).map { article -> String in
            guard let article = article else {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failArticleNoExisted).makeResponse()
            }
            
            return ResponseWrapper(protocolCode: .success, obj: article).makeResponse()
        }
    }
    
    /// 查询某个用户的所有文章
    func fetchUserArticleList(req: Request) throws -> EventLoopFuture<String> {
        guard let userId = req.parameters.get("userId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        return Article.query(on: req.db).filter(\.$authorId == userId).all().map { articleList in
            return ResponseWrapper(protocolCode: .success, obj: articleList).makeResponse()
        }
    }
    
    /// 查询文章作者详情
    func fetchArticleUserDetail(req: Request) throws -> EventLoopFuture<String> {
        guard let articleId = req.parameters.get("articleId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        return Article.find(articleId, on: req.db).flatMap { article -> EventLoopFuture<String> in
            guard let article = article else {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failArticleNoExisted).makeFutureResponse(req: req)
            }
            
            return User.find(article.authorId, on: req.db).map { user -> String in
                let articleUser = ArticleUser(user: user!, article: article)
                
                return ResponseWrapper(protocolCode: .success, obj: articleUser).makeResponse()
            }
        }
    }
    
    /// 删除文章
    func delete(req: Request) throws -> EventLoopFuture<String> {
        guard let articleId = req.parameters.get("articleId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        let article = Article()
        article.id = articleId
        return article.delete(on: req.db).map {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
        }
    }
}
