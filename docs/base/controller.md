# Controller

`Controller` 可以使得代码结构更清晰，它是处理 request 和 response 的一系列方法集合。

## 创建 Controller

首先，我们在 `Controllers` 目录下创建一个新的 ```TestController.swift``` 文件 ，代码如下

``` swift
import Vapor

struct TestController {
    
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

## 绑定 Controller

接下来，在 `routes.swift` 文件中进行绑定操作。

``` swift
func routes(_ app: Application) throws {
    ......
    
    let testController = TestController()

    // 请求路径：test，请求方法: POST，响应方法：createUser。
    app.post("test", use: testController.createUser)

    // 请求路径：test，请求方法: PUT，响应方法：updateUser。
    app.put("test", use: testController.updateUser)

    // 请求路径：test，参数：<userId>, 请求方法: GET，响应方法：findUser。
    app.get("test", ":userId", use: testController.findUser)

    // 请求路径：test，参数：<userId>, 请求方法: DELETE，响应方法：deleteUser。
    app.delete("test", ":userId", use: testController.deleteUser)
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