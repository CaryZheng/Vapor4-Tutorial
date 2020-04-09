# macOS 安装 Vapor

## 安装 Xcode

因为 Vapor 4 需要 Swift 5.2（或以上） 版本，所以需要先安装 Xcode 11.4（或以上）。

通过以下命令来确认当前 Swift 版本。

```
swift --version
```

将显示对应的 Swift 版本信息。

```
Apple Swift version 5.2 (swiftlang-1103.0.32.1 clang-1103.0.32.29)
Target: x86_64-apple-darwin19.4.0
```

## 安装 Toolbox

执行以下命令。

```
brew install vapor/tap/vapor
```

安装成功后，执行以下命令，将显示可用的命令列表。

```
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
