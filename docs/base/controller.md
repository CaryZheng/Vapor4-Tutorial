# Controller

`Controller` 可以使得代码结构更清晰，它是处理 `request` 和 `response` 的一系列方法集合。

## 创建 Controller

首先，我们在 `Controllers` 目录下创建一个新的 `TestController.swift` 文件 ，代码如下

``` swift
import Vapor

struct TestController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userRoute = routes.grouped("user")
        userRoute.get(":userId", use: findUser)
        userRoute.post(use: createUser)
        userRoute.put(use: updateUser)
        userRoute.delete(":userId", use: deleteUser)
    }
    
    func createUser(req: Request) -> String {
        return "Create SwiftMic test user"
    }

    func updateUser(req: Request) -> String {
        return "Update SwiftMic test user"
    }

    func findUser(req: Request) -> String {
        let userId = req.parameters.get("userId")
        if nil == userId || userId!.isEmpty {
            return "Require param: userId"
        }

        return "Find SwiftMic test user: " + userId!
    }

    func deleteUser(req: Request) -> String {
        let userId = req.parameters.get("userId")
        if nil == userId || userId!.isEmpty {
            return "Require param: userId"
        }

        return "Delete SwiftMic test user: " + userId!
    }
}
```

此处，`TestController` 结构体中定义了 4 个方法（`createUser`、`updateUser`、`findUser`、`deleteUser`），它们都接收了一个 `Request` 请求，处理完后返回一个 `Response`（此处为 `String` 类型）。

!!! note

	上述示例代码展示了 `controller` 的基本使用方式，并未接入任何数据库。数据库相关内容将会在后续教程中进行详细介绍。

## 绑定 Controller

在 `TestController.swift` 文件中的 `boot` 方法中设置路由与具体响应方法之间的绑定关系。

```swift
func boot(routes: RoutesBuilder) throws {
    let routeBuilder = routes.grouped("test")
    
    // 请求路径：test，参数：<userId>, 请求方法: GET，响应方法：findUser。
    routeBuilder.get(":userId", use: findUser)
    
    // 请求路径：test，请求方法: POST，响应方法：createUser。
    routeBuilder.post(use: createUser)
    
    // 请求路径：test，请求方法: PUT，响应方法：updateUser。
    routeBuilder.put(use: updateUser)
    
    // 请求路径：test，参数：<userId>, 请求方法: DELETE，响应方法：deleteUser。
    routeBuilder.delete(":userId", use: deleteUser)
}
```

接下来，在 `routes.swift` 文件中进行注册操作。

``` swift
func routes(_ app: Application) throws {
    ......
    
    try app.register(collection: TestController())
}
```

## 测试 API

最后，通过 [CURL](https://curl.haxx.se/) 工具模拟 HTTP 请求来测试下这 4 个接口。

### GET

* Request

```
curl -X GET http://localhost:8080/test/1
```

* Response

```
Find SwiftMic test user: 1
```

### POST

* Request

```
curl -X POST http://localhost:8080/test
```

* Response

```
Create SwiftMic test user
```

### PUT

* Request

```
curl -X PUT http://localhost:8080/test
```

* Response

```
Update SwiftMic test user
```

### DELETE

* Request

```
curl -X DELETE http://localhost:8080/test/1
```

* Response

```
Delete SwiftMic test user: 1
```