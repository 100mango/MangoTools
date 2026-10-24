@import MangoToolsObjC;
#import <QuartzCore/QuartzCore.h>
#import "ConsumerObjC.h"

bool publicObjectiveCCategoriesWork(void) {
    NSString *formatted = [NSString timeStringFromSeconds:61];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:1000];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view ClipSquareViewToRound];
    return [formatted isEqualToString:@"00:01:01"]
        && [[date dateByAddingMinutes:2] minutesAfterDate:date] == 2
        && view.layer.cornerRadius == 10;
}
