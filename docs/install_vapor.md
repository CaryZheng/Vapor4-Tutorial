# 开发环境

目前 `Swift` 官方支持 `macOS` 和 `Ubuntu` 操作系统，本教程讲解的是如何在 `macOS` 搭建 `Vapor` 开发环境。

## 安装 Xcode

因为 `Vapor 4` 需要 `Swift 5.2（或以上）` 版本，所以需要先安装 `Xcode 11.4（或以上）`。

通过以下命令来确认当前 Swift 版本。

```shell
swift --version
```

将显示对应的 `Swift` 版本信息。

```shell
swift-driver version: 1.45.2 Apple Swift version 5.6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)
Target: arm64-apple-macosx12.0
```

!!! note

    作者使用的是 `Swift 5.6` 版本，此处会展示你实际安装的 `Swift` 版本号。

## 安装 Toolbox

执行以下命令

```shell
brew install vapor
```

!!! note

	`brew` 安装方法可参考: [https://brew.sh](https://brew.sh/)

安装成功后，执行以下命令，将显示可用的命令列表。

```shell
$ vapor --help
Usage: vapor <command>

Vapor Toolbox (Server-side Swift web framework)

Commands:
       build Builds an app in the console.
       clean Cleans temporary files.
      heroku Commands for working with Heroku.
         new Generates a new app.
         run Runs an app from the console.
             Equivalent to `swift run Run`.
             The --enable-test-discovery flag is automatically set if needed.
  supervisor Commands for working with supervisord.
       xcode Opens an app in Xcode.

Use `vapor <command> [--help,-h]` for more information on a command.
```

## 常用命令介绍

* 初始化 `Vapor` 新项目

```shell
vapor new <项目名>
```

* 编译项目

```shell
vapor build
```

* 运行项目

```shell
vapor run
```

* 生成 `Xcode` 项目

```shell
vapor xcode
```

* 清理 `Vapor` 项目

```shell
vapor clean
```

!!! note
	`clean` 命令会删除项目中的临时文件。如果遇到比较奇怪的编译错误，也可以尝试 `clean` 下。

## Ubuntu

基于 `Ubuntu` 的 `Vapor` 环境，具体步骤可参考：[Vapor 官网](https://docs.vapor.codes/4.0/install/linux/)