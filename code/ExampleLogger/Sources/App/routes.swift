import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        req.logger.trace("hello log trace")
        req.logger.debug("hello log debug")
        req.logger.info("hello log info")
        req.logger.notice("hello log notice")
        req.logger.warning("hello log warning")
        req.logger.error("hello log error")
        req.logger.critical("hello log critical")
        
        return "Hello, world!"
    }
}
