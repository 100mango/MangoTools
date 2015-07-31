//
//  MangoLog.h
//
//  Created by Mango on 15/7/24.
//

#import <Foundation/Foundation.h>

@class MangoLog;

#define MGLog(format, ...) \
do \
{ \
    NSString *position = [NSString stringWithFormat:@"%s [Line %d]\n", \
                          __PRETTY_FUNCTION__,__LINE__]; \
    NSString *userDefineString = [NSString stringWithFormat:format,##__VA_ARGS__]; \
    NSString *logString = [NSString stringWithFormat:@"%@%@",position,userDefineString]; \
    NSLog(@"%@",logString); \
    [MangoLog writeLogString:logString];\
} while (0);\

#define MGLogWithoutWriteFile(format, ...) \
do \
{ \
    NSString *position = [NSString stringWithFormat:@"%s [Line %d]\n", \
                          __PRETTY_FUNCTION__,__LINE__]; \
    NSString *userDefineString = [NSString stringWithFormat:format,##__VA_ARGS__]; \
    NSString *logString = [NSString stringWithFormat:@"%@%@",position,userDefineString]; \
    NSLog(@"%@",logString); \
} while (0);\

@interface MangoLog : NSObject

+ (void)writeLogString:(NSString*)logString;

@end
