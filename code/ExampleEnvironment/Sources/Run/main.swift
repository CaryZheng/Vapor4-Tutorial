import App
import Vapor

//var env = Environment(name: "testing", arguments: ["vapor"])
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
