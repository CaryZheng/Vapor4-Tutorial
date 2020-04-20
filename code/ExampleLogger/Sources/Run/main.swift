import App
import Vapor

let myLogger = Logger(label: "com.swiftmic.logger")
myLogger.info("This is message from myLogger")

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

//// 自定义 log handler
//LoggingSystem.bootstrap { label in
//    StreamLogHandler.standardOutput(label: label)
//}

let app = Application(env)
defer { app.shutdown() }

app.logger.info("Start to config")

try configure(app)
try app.run()
