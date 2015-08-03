MyTools_iOS
===========
#个人收集与编写维护的一个iOS开发工具库

###1.UIView+Tools 
**recognizer封装**

封装了UITapGestureRecognizer等Recognizer,使用Block作为动作触发的回调。

**layer**
便捷地修改UIView的layer属性，添加不同方向的border,裁剪为圆


###2.NSDate+Utilities
便捷的时间对比与计算。
例如：

~~~obj-c
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isTheDayAfterTomorrow;
~~~


###3.JZLocationConverter
便捷的地理位置坐标转换器，将火星坐标转到地球坐标等便捷中国特色功能


###4.HudTools
便捷的hud通知调用，全部通过类方法调用。方便快捷。


###5.NSString+Tools.h
一些检测String的便捷方法 封装了正则匹配等一些匹配。

~~~objective-c
- (BOOL)isMobileNumber:(NSString *)mobileNum
- (BOOL)isCarNumber;
- (BOOL)isURL;
+ (NSURL *)HTTPURLFromString:(NSString *)string;
~~~

###6.NSObject+Macro
一些常用的宏：

例如检测设备

~~~objective-c
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
~~~

定制NSLog:

~~~objective-c
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
~~~

###7.EXTScope
来自[libextobjc](https://github.com/jspahrsummers/libextobjc)中的一个模块。感谢它为我们带来方便打破block循环引用的工具。

用法:

~~~objective-c
@weakify(self)
[self.context performBlock:^{
    // Analog to strongSelf in previous code snippet.
    @strongify(self)

    // You can just reference self as you normally would. Hurray.
    NSError *error;
    [self.context save:&error];

    // Do something
}];
~~~

延伸:
[iOS夯实：ARC时代的内存管理](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/%23iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.md)

###8.MangoLog

简单的日志工具。直接通过LOG保存Debug信息到文件。

已确保线程安全,简单易扩展。