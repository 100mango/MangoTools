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