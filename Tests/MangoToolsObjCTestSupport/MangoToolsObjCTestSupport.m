#import "MangoToolsObjCTestSupport.h"
#import "MangoToolsObjC.h"
#import <QuartzCore/QuartzCore.h>

bool MangoToolsStringUtilitiesWork(void) {
    return [[NSString timeStringFromSeconds:3661] isEqualToString:@"01:01:01"]
        && [[[NSString HTTPURLFromString:@"example.com/path"] absoluteString]
            isEqualToString:@"http://example.com/path"]
        && [@"A1234" isCarNumber]
        && ![@"!1234" isCarNumber];
}

bool MangoToolsDateUtilitiesWork(void) {
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:100000];
    NSDate *later = [date dateByAddingHours:2];
    return [later hoursAfterDate:date] == 2
        && [later minutesAfterDate:date] == 120
        && [date isEarlierThanDate:later]
        && [[later dateBySubtractingHours:2] isEqualToDate:date];
}

bool MangoToolsAttributedStringUtilitiesWork(void) {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    [text addFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, text.length)];
    [text addItalic:YES range:NSMakeRange(0, text.length)];
    NSRange range;
    if (![text italicAtIndex:0 effectiveRange:&range]) return false;
    [text addItalic:NO range:NSMakeRange(0, text.length)];
    if ([text italicAtIndex:0 effectiveRange:&range]) return false;
    [text addBold:YES range:NSMakeRange(0, text.length)];
    return [text boldAtIndex:0 effectiveRange:&range];
}

bool MangoToolsViewUtilitiesWork(void) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view ClipSquareViewToRound];
    if (view.layer.cornerRadius != 10) return false;
    [view addBottomBorderWithColor:UIColor.redColor andWidth:2];
    if (view.layer.sublayers.count != 1) return false;
    __block bool tapped = false;
    [view touchEndedBlock:^(UIView *sender) { tapped = sender == view; }];
    [view touchEndedGesture];
    // Do not leave a captured-view cycle in the test.
    [view touchEndedBlock:nil];
    [view shakeHorizontally];
    bool animated = [view isBeingAnimated];
    [view stopAnimation];
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"hello mango" highlightKeyWord:@[@"mango"] highlightColor:UIColor.redColor];
    return tapped && animated && ![view isBeingAnimated]
        && [label.attributedText.string isEqualToString:@"hello mango"];
}

bool MangoToolsScopeUtilitiesWork(void) {
    __block bool exited = false;
    {
        @onExit { exited = true; };
    }
    return exited;
}
