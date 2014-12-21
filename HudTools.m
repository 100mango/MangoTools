//
//  shike
//
//  Copyright (c) 2014年 shixun. All rights reserved.
//

#import "HudTools.h"
#import "SVProgressHUD.h"

@interface HudTools()

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end


@implementation HudTools

- (id)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
    }
    return self;
}

+ (HudTools *)shareInstance
{
    static HudTools *g_tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_tools = [[HudTools alloc] init];
        
    });
    
    return g_tools;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

+ (void)showStatusWithString:(NSString *)string
{
    [SVProgressHUD showWithStatus:string maskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)showSuccessWithString:(NSString *)string
{
    [SVProgressHUD showSuccessWithStatus:string];
    
    HudTools *tools = [HudTools shareInstance];
    [tools.timer invalidate];
    tools.timer = nil;
    tools.timer = [NSTimer timerWithTimeInterval:1.5 target:tools selector:@selector(dismiss) userInfo:nil repeats:NO];
    
}

+ (void)showErrorWithString:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
    HudTools *tools = [HudTools shareInstance];
    [tools.timer invalidate];
    tools.timer = nil;
    tools.timer = [NSTimer timerWithTimeInterval:1.5 target:tools selector:@selector(dismiss) userInfo:nil repeats:NO];
}


@end
