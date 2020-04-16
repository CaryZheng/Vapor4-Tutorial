# 开发环境

目前 `Swift` 官方支持 `macOS` 和 `Ubuntu` 操作系统，本教程讲解的是如何在 `macOS` 搭建 `Vapor` 开发环境。

## 安装 Xcode

因为 `Vapor 4` 需要 `Swift 5.2（或以上）` 版本，所以需要先安装 `Xcode 11.4（或以上）`。

通过以下命令来确认当前 Swift 版本。

```shell
swift --version
```

将显示对应的 Swift 版本信息。

```shell
Apple Swift version 5.2 (swiftlang-1103.0.32.1 clang-1103.0.32.29)
Target: x86_64-apple-darwin19.4.0
```

## 安装 Toolbox

执行以下命令。

```shell
brew install vapor/tap/vapor
```

安装成功后，执行以下命令，将显示可用的命令列表。

```shell
$ vapor -help
Usage: vapor command

Join our team chat if you have questions, need help,
or want to contribute: http://vapor.team

Commands:
       new Creates a new Vapor application from a template.
           Use --template=repo/template for github templates
           Use --template=full-url-here.git for non github templates
           Use --web to create a new web app
           Use --auth to create a new authenticated API app
           Use --api (default) to create a new API
     build Compiles the application.
       run Runs the compiled application.
     fetch Fetches the application's dependencies.
    update Updates your dependencies.
     clean Cleans temporary files--usually fixes
           a plethora of bizarre build errors.
      test Runs the application's tests.
     xcode Generates an Xcode project for development.
           Additionally links commonly used libraries.
   version Displays Vapor CLI version
     cloud Commands for interacting with Vapor Cloud.
    heroku Commands to help deploy to Heroku.
  provider Commands to help manage providers.

Use `vapor command --help` for more information on a command.
```

## 常用命令介绍

* 初始化 `Vapor` 新项目

```shell
vapor new <项目名> -branch=4
```

* 编译项目

```shell
vapor build
```

* 运行项目

```shell
vapor run
```

* 更新相关依赖库

```shell
vapor update
```

* 生成 `Xcode` 项目

```shell
vapor xcode
```

* 清理 `Vapor` 项目

```shell
vapor clean
```

> 注意
> 
> `clean` 命令会删除项目中的临时文件。如果遇到比较奇怪的编译错误，也可以尝试 `clean` 下。

## Ubuntu

基于 `Ubuntu` 的 `Vapor` 环境，具体步骤可参考：[Vapor 官网](https://docs.vapor.codes/4.0/install/ubuntu/)