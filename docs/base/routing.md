# Routing

路由是用来管理控制 HTTP 请求入口的。

先看下 `App` 目录下的 `routes.swift` 文件，源码如下。

```swift
func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.on(.DELETE, "todos", ":todoID", use: todoController.delete)
    
    let testController = TestController()
    app.post("test", use: testController.createUser)
    app.put("test", use: testController.updateUser)
    app.get("test", ":userId", use: testController.findUser)
    app.delete("test", ":userId", use: testController.deleteUser)
    
    // 路由组
	app.group("v1") { builder in
	    
	    // 此处定义的所有请求路径都是在路由组（"v1"）下面的。
	    builder.get("name") { req in
	        return "Handle path: v1/name"
	    }
	    
	    builder.get("avatar") { req in
	        return "Handle path: v1/avatar"
	    }
	}
}
```

通过 `app`（`Application` 类实例）可以对路由进行相关的配置。

## 监听指定路径

```
app.get("hello") { req in
    return "Hello, world!"
}
```

如上代码的作用是，监听了 "hello" 路径，当客户端发起 `/hello` 为路径的 `GET` 请求时，将会出发该回调方法的执行，最终返回 "Hello, world!" 给客户端展现。

接下来我们测试下。

* Request

```
curl -X GET http://localhost:8080/hello
```

* Response

```
Hello, world!
```

同理，`POST`、`PUT`、`DELETE` 等操作行为也是类似的。

示例如下

```
// Method: POST, Path: test1
app.post("test1") { req in
    return "Method: POST, Path: test1"
}

// Method: PUT, Path: test2
app.put("test2") { req in
    return "Method: PUT, Path: test2"
}

// Method: DELETE, Path: test3
app.delete("test3") { req in
    return "Method: DELETE, Path: test3"
}
```

## 监听指定路径集合

有时候定义的路径都是在某一个特定路径名下的（比如 `v1`），这时候就需要路由组来进行管理了。

```
// 路由组
app.group("v1") { builder in
    
    // 此处定义的所有请求路径都是在路由组（"v1"）下面的。
    builder.get("name") { req in
        return "Handle path: v1/name"
    }
    
    builder.get("avatar") { req in
        return "Handle path: v1/avatar"
    }
}
```

`name` 和 `avatar` 都是挂在 `v1` 后面，相当于 `v1/name` 和 `v1/avatar`。

接下来我们测试下。

* Request

```
curl -X GET http://localhost:8080/v1/name
```

* Response

```
Handle path: v1/name
```

* Request

```
curl -X GET http://localhost:8080/v1/avatar
```

* Response

```
Handle path: v1/avatar
```