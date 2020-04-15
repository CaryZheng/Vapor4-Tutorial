# MySQL

## 创建 MySQL 数据库

```sql
-- 创建数据库
CREATE DATABASE swift_fluent_test DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE swift_fluent_test;

-- 创建user表
CREATE TABLE user (
	id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(255) NOT NULL COMMENT '用户名',
	PRIMARY KEY(id)
);

-- 创建article表
CREATE TABLE article (
	id INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(255) NOT NULL	COMMENT '标题',
	content LONGTEXT NOT NULL	COMMENT '正文',
	authorId INT NOT NULL	COMMENT '作者Id',
	cover VARCHAR(255) NULL COMMENT '封面',
	PRIMARY KEY(id)
);
```

## 配置

编辑 `Package.swift` 文件，增加 `MySQL` 相关依赖。

```swift
dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0-rc"),
    ],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
        .product(name: "Vapor", package: "vapor")
    ]),
    ......
]
```

在当前项目目录下，执行 `vapor update` 命令，更新 Package.swift 配置的相关依赖。

然后，编辑 `configure.swift` 文件，增加如下代码：

```swift
import Fluent
import FluentMySQLDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // config MySQL
    app.databases.use(.mysql(hostname: "127.0.0.1", port: 3306, username: "root", password: "YourPassword", database: "swift_mic_test", tlsConfiguration: nil), as: .mysql)
    
    ......
}
```

> 注意
> 
>  具体参数以实际配置为准，可能与上述配置参数有出入。

至此，`MySQL` 相关配置已就绪。

## Model

假如我们需要实现一个用户的增删改查操作：

* 注册一个用户（增）
* 查询一个用户信息（查）
* 修改一个用户信息（改）
* 删除一个用户（删）

此时，需要构造数据库要用到的 `Model`。假设数据库 `user` 表中有两个字段，分别为 `主键id` 和 `username` 字段，按如下代码创建 `User` 类：

```swift
import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "username")
    var username: String

    init() {}

    init(id: Int? = nil, title: String) {
        self.id = id
        self.username = title
    }
}
```

其中，`schema ` 值对应的是数据库表名。

`@ID(custom: "id")` 关联的是 `user` 表中的 `主键id` 字段。

`@Field(key: "username")` 关联的是 `user` 表中的 `username ` 字段。

最后，让 `User` 类实现 `Model` 协议即可。

## Controller

创建 `UserController` 类：

```swift
import Vapor
import Fluent

class UserController {
    
    /// 创建用户
    func createUser(req: Request) throws -> EventLoopFuture<String> {
        let userInput = try req.content.decode(UserInput.self)
        
        let user = User(username: userInput.username)
        
        return user.save(on: req.db).map {
            let userResponse = UserResponse(id: user.id!, username: user.username)
            return ResponseWrapper(protocolCode: .success, obj: userResponse).makeResponse()
        }
    }
    
    /// 查找用户
    func findUser(req: Request) -> EventLoopFuture<String> {
        guard let userId = req.parameters.get("userId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        return User.find(userId, on: req.db).map { user -> String in
            guard let user = user else {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeResponse()
            }
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
    }
    
    /// 更新用户
    func updateUser(req: Request) throws -> EventLoopFuture<String> {
        let user = try req.content.decode(User.self)
        let username = user.username
        
        return User.find(user.id!, on: req.db).flatMap { newUser -> EventLoopFuture<String> in
            if nil == newUser {
                return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeFutureResponse(req: req)
            }
            
            newUser!.username = username
            return newUser!.update(on: req.db).map {
                return ResponseWrapper(protocolCode: .success, obj: newUser!).makeResponse()
            }
        }
    }
    
    /// 删除用户
    func deleteUser(req: Request) -> EventLoopFuture<String> {
        guard let userId = req.parameters.get("userId") as Int? else {
            // 参数错误
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failParamError).makeFutureResponse(req: req)
        }
        
        let user = User()
        user.id = userId
        return user.delete(on: req.db).map {
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
        }
    }
}
```

## Route

编辑 `routes.swift` 文件，增加如下代码：

```swift
func routes(_ app: Application) throws {
    ......
    
    let userController = UserController()
    app.post("user", use: userController.createUser)
    app.get("user", ":userId", use: userController.findUser)
    app.put("user", use: userController.updateUser)
    app.delete("user", ":userId", use: userController.deleteUser)
    
    ......
}
```

## 使用原生 SQL

编辑 `routes.swift` 文件，增加如下代码：

```swift
app.get(["user", "top10"], use: userController.fetchUserTop10)
```

编辑 `UserController.swift` 文件，增加如下代码：

```swift
/// 查询前10个用户信息
func fetchUserTop10(req: Request) throws -> EventLoopFuture<String> {
    let sql = """
        SELECT * FROM user LIMIT 10;
    """
    return (req.db as! MySQLDatabase).sql().raw(SQLQueryString(sql)).all(decoding: User.self).map { users in
        print("user = \(users)")
        
        return ResponseWrapper(protocolCode: .success, obj: users).makeResponse()
    }
}
```

`raw` 查询也支持 `all()`、`first()`、`run()` 方法。

## 测试

启动服务后，可构造如下 `HTTP` 请求进行测试。

### 创建用户

* Request

```shell
curl --location --request POST 'localhost:8080/user' \
--header 'Content-Type: application/json' \
--data-raw '{
	"username": "zzb5"
}'
```

* Response

```shell
{
    "msg": "success",
    "obj": {
        "id": 5,
        "username": "zzb5"
    },
    "code": 200
}
```

### 查询用户信息

* Request

```shell
curl --location --request GET 'localhost:8080/user/5'
```

* Response

```shell
{
    "msg": "success",
    "obj": {
        "id": 5,
        "username": "zzb5"
    },
    "code": 200
}
```

### 更新用户信息

* Request

```shell
curl --location --request PUT 'localhost:8080/user' \
--header 'Content-Type: application/json' \
--data-raw '{
	"id": 5,
	"username": "zzb5_new"
}'
```

* Response

```shell
{
    "msg": "success",
    "obj": {
        "id": 5,
        "username": "zzb5_new"
    },
    "code": 200
}
```

### 删除用户

* Request

```shell
curl --location --request DELETE 'localhost:8080/user/5' \
--data-raw ''
```

* Response

```shell
{
    "msg": "success",
    "code": 200
}
```

## 源码

可参考源码：[ExampleMySQL](https://github.com/CaryZheng/Vapor4-Tutorial/tree/master/code/ExampleMySQL)