# MangoTools

个人收集整理与编写维护的一个 iOS 开发工具库


## Swift Package Manager

新增 SwiftPM 包配置，要求 Swift 5.5+，新包声明 iOS 9.0+。UIKit / Objective-C 功能需要
使用 Xcode 的 iOS SDK 构建，不能在 Linux 或 macOS 命令行目标下直接使用。
导出源码不需要 iOS 12 新 API；iOS 9 是新包的兼容性下限声明，尚不代表旧设备已验证。
当前测试脚本单独使用 iOS 15+ 模拟器测试部署目标，不改变库的最低系统版本，
也不改变手动复制源码使用方自己的 deployment target。较老系统需要选用仍支持它的 Xcode。

这是**有明确排除项的迁移**，不是所有历史 API 的无缝升级：
`StructCoding.swift` 的任意结构体原始内存序列化不安全，`HudTools` 的
SVProgressHUD 依赖缺失且调用了历史 API，因此两者保留原文件，但不导出到 SwiftPM。
具体兼容范围、迁移选项和验证方式见
[SwiftPM 迁移说明](Documentation/SwiftPM-Migration.md)。

在 Xcode 选择 File → Add Package Dependencies，输入本仓库 URL，选择包含
`Package.swift` 的分支或提交（历史 tag 不一定含包配置），添加 `MangoTools` product。
也可以先用本地路径验证：

```swift
// In your Package.swift dependencies:
.package(path: "../MangoTools")

// In your target dependencies:
.product(name: "MangoTools", package: "MangoTools")
```

```swift
import UIKit
import MangoTools      // Swift UIView / cell helpers
import MangoToolsObjC  // Objective-C utilities, when needed

let view = UIView()
view.width = 120
```

只有 Objective-C 工具的使用方可以选择 `MangoToolsObjC` product，通过
`@import MangoToolsObjC;` 使用。原有源文件路径保留，不要同时手动编译相同文件，
以免产生重复符号。新增的测试可在装有 iOS Simulator 的 Mac 上运行：

```sh
Scripts/test-ios.sh
```


### 1.UIView+Tools 

**recognizer 封装**

封装了 UITapGestureRecognizer 等 Recognizer，使用 Block 作为动作触发的回调。

**layer**

便捷地修改 UIView 的 layer 属性，添加不同方向的 border，裁剪为圆。

### 2.NSDate+Utilities

便捷的时间对比与计算。

例如：

```obj-c
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isTheDayAfterTomorrow;
```

### 3.[JZLocationConverter](https://github.com/JackZhouCn/JZLocationConverter)

便捷的地理位置坐标转换器，将火星坐标转到地球坐标等便捷中国特色功能

### 4.HudTools

便捷的hud通知调用，全部通过类方法调用。方便快捷。

### 5.NSString+Tools.h

一些检测 String 的便捷方法，封装了正则匹配等一些匹配。

```objective-c
- (BOOL)isMobileNumber:(NSString *)mobileNum
- (BOOL)isCarNumber;
- (BOOL)isURL;
+ (NSURL *)HTTPURLFromString:(NSString *)string;
```

### 6.NSObject+Macro

一些常用的宏：

例如检测设备

```objective-c
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
```

定制 NSLog:

```objective-c
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
```

### 7.EXTScope

来自 [libextobjc](https://github.com/jspahrsummers/libextobjc) 中的一个模块。感谢它为我们带来方便打破 block 循环引用的工具。

用法:

```objective-c
@weakify(self)
[self.context performBlock:^{
    // Analog to strongSelf in previous code snippet.
    @strongify(self)

    // You can just reference self as you normally would. Hurray.
    NSError *error;
    [self.context save:&error];

    // Do something
}];
```

延伸:

[iOS 夯实：ARC 时代的内存管理](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/%23iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.md)

### 8.MangoLog

简单的日志工具。直接通过 LOG 保存 Debug 信息到文件。

已确保线程安全,简单易扩展。
