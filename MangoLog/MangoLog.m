//
//
//  Created by Mango on 15/7/24.
//

#import "MangoLog.h"

@implementation MangoLog

+ (void)writeLogString:(NSString *)logString
{
    //格式化字符串 添加日期
    /**  示例:
     *  <2015-07-24 11:21:57 +0000
        -[AppDelegate applicationDidFinishLaunching:] [Line 20]
        hello world>
     */
    logString = [NSString stringWithFormat:@"<\n %@\n%@ \n>\n",[NSDate date],logString];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *document =  [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *directory = [document URLByAppendingPathComponent:@"mangoLog"];
    [fileManager createDirectoryAtURL:directory withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL *textPath = [directory URLByAppendingPathComponent:@"mangoLog.txt"];
    
    if (![fileManager fileExistsAtPath:[textPath path]]) {
        
        //dispatch_barrier处理单一资源多读单写
        dispatch_barrier_async([self sharedQueue], ^{

            [[logString dataUsingEncoding:NSUTF8StringEncoding] writeToURL:textPath atomically:YES];
        });
    }else{
        
        dispatch_barrier_async([self sharedQueue], ^{
            NSFileHandle *handel = [NSFileHandle fileHandleForWritingToURL:textPath error:nil];
            [handel truncateFileAtOffset:[handel seekToEndOfFile]];
            [handel writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
            [handel closeFile];
        });
    }
    
}

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_once_t onceToken;
    static dispatch_queue_t sharedQueue;
    dispatch_once(&onceToken, ^{
        sharedQueue = dispatch_queue_create([@"mango.barrierQueue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    });
    return sharedQueue;
}

@end
