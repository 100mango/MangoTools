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

bool MangoToolsStringBoundariesWork(void) {
    const int seconds[] = {0, 59, 60, 3599, 3600, 360000};
    NSArray<NSString *> *expected = @[@"00:00:00", @"00:00:59", @"00:01:00", @"00:59:59", @"01:00:00", @"100:00:00"];
    for (NSUInteger index = 0; index < expected.count; index++) {
        if (![[NSString timeStringFromSeconds:seconds[index]] isEqualToString:expected[index]]) return false;
    }
    return ![@"" isCarNumber] && ![@"1234" isCarNumber] && ![@"123456" isCarNumber]
        && [@"aZ_09" isCarNumber] && ![@"AB 12" isCarNumber];
}

bool MangoToolsURLSchemesWork(void) {
    NSArray<NSString *> *urls = @[@"https://example.com/a?b=c#d", @"http://example.com", @"HTTP://example.com"];
    for (NSString *url in urls) {
        if (![[NSString HTTPURLFromString:url] isEqual:[NSURL URLWithString:url]]) return false;
    }
    return [[[NSString HTTPURLFromString:@"example.com"] absoluteString] isEqualToString:@"http://example.com"];
}

bool MangoToolsDateBoundariesWork(void) {
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:100000];
    return [[date dateByAddingHours:0] isEqualToDate:date]
        && [[date dateByAddingMinutes:-1] seconds] == [date seconds]
        && [[date dateByAddingMinutes:-1] minutesBeforeDate:date] == 1
        && [[date dateByAddingMinutes:1] minutesAfterDate:date] == 1
        && [date minutesAfterDate:[date dateByAddingTimeInterval:-59]] == 0
        && [date minutesAfterDate:[date dateByAddingTimeInterval:-60]] == 1
        && [[date dateBySubtractingMinutes:3] dateByAddingMinutes:3].timeIntervalSinceReferenceDate == date.timeIntervalSinceReferenceDate;
}

bool MangoToolsAttributedSubrangesWork(void) {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"abcdef"];
    UIFont *plain = [UIFont systemFontOfSize:12];
    [text addFont:plain range:NSMakeRange(0, 6)];
    [text addFont:[UIFont systemFontOfSize:18] range:NSMakeRange(3, 1)];
    NSRange middle = NSMakeRange(2, 3);
    [text addBold:YES range:middle];
    [text addItalic:YES range:middle];
    [text addFontSize:22 range:middle];
    for (NSUInteger index = 0; index < 6; index++) {
        NSRange effective;
        BOOL inside = NSLocationInRange(index, middle);
        if ([text boldAtIndex:index effectiveRange:&effective] != inside) return false;
        if ([text italicAtIndex:index effectiveRange:&effective] != inside) return false;
        if ([text fontSizeAtIndex:index effectiveRange:&effective] != (inside ? 22 : 12)) return false;
    }
    [text addBold:NO range:middle];
    [text addItalic:NO range:middle];
    for (NSUInteger index = 2; index < 5; index++) {
        NSRange effective;
        if ([text boldAtIndex:index effectiveRange:&effective] || [text italicAtIndex:index effectiveRange:&effective]) return false;
    }
    return true;
}

bool MangoToolsAttributedDefaultsWork(void) {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    NSRange range;
    if ([text fontSizeAtIndex:0 effectiveRange:&range] != 12) return false;
    if (![[text fontNameAtIndex:0 effectiveRange:&range] isEqualToString:@"Helvetica"]) return false;
    [text addFontSize:0 range:NSMakeRange(0, 3)];
    if ([text attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL]) return false;
    [text addFontName:@"A font that does not exist" range:NSMakeRange(0, 3)];
    return [text attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL] == nil;
}

bool MangoToolsBorderGeometryWorks(void) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 80)];
    [view addTopBorderWithColor:UIColor.redColor andWidth:2];
    [view addBottomBorderWithColor:UIColor.redColor andWidth:3];
    [view addLeftBorderWithColor:UIColor.redColor andWidth:4];
    [view addRightBorderWithColor:UIColor.redColor andWidth:5];
    NSArray<CALayer *> *layers = view.layer.sublayers;
    if (layers.count != 4) return false;
    if (!CGRectEqualToRect(layers[0].frame, CGRectMake(0, 0, 100, 2))) return false;
    if (!CGRectEqualToRect(layers[1].frame, CGRectMake(0, 77, 100, 3))) return false;
    if (!CGRectEqualToRect(layers[2].frame, CGRectMake(0, 0, 4, 80))) return false;
    if (!CGRectEqualToRect(layers[3].frame, CGRectMake(95, 0, 5, 80))) return false;
    [view ClipSquareViewToRound];
    return view.layer.cornerRadius == 0;
}

bool MangoToolsAnchorPointPreservesOrigin(void) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 80)];
    CGRect frame = view.frame;
    [view setAnchorPointAndRemainOrigin:CGPointZero];
    if (!CGRectEqualToRect(view.frame, frame)) return false;
    [view setAnchorPointAndRemainOrigin:CGPointMake(1, 1)];
    return CGRectEqualToRect(view.frame, frame) && CGPointEqualToPoint(view.layer.anchorPoint, CGPointMake(1, 1));
}

bool MangoToolsGestureReplacementWorks(void) {
    UIView *view = [[UIView alloc] init];
    __block NSInteger first = 0;
    __block NSInteger replacement = 0;
    [view touchEndedBlock:^(UIView *sender) { first++; }];
    [view touchEndedGesture];
    [view touchEndedBlock:^(UIView *sender) { replacement++; }];
    [view touchEndedGesture];
    [view touchEndedBlock:nil];
    [view touchEndedGesture];
    return first == 1 && replacement == 1 && view.userInteractionEnabled;
}

bool MangoToolsLabelBoundariesWork(void) {
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Mango mango" highlightKeyWord:@[@"mango"] highlightColor:UIColor.redColor];
    NSAttributedString *highlighted = label.attributedText;
    if (![[highlighted attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL] isEqual:UIColor.redColor]) return false;
    if (![[highlighted attribute:NSForegroundColorAttributeName atIndex:6 effectiveRange:NULL] isEqual:UIColor.redColor]) return false;
    if ([highlighted attribute:NSForegroundColorAttributeName atIndex:5 effectiveRange:NULL] != nil) return false;
    [label setText:@"a\nb" highlightKeyWord:@[] highlightColor:UIColor.redColor];
    if (![label.text isEqualToString:@"ab"]) return false;
    [label setText:@"" highlightKeyWord:@[@"mango"] highlightColor:UIColor.redColor];
    return [label.text isEqualToString:@""];
}

bool MangoToolsImageRenderingWorks(void) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    view.backgroundColor = UIColor.redColor;
    UIImage *image = [view renderWithBounds:view.bounds];
    if (!image || !CGSizeEqualToSize(image.size, CGSizeMake(20, 30))) return false;
    UIImage *rounded = [UIView imageWithRoundedCornersSize:3 usingImage:image];
    if (!rounded || !CGSizeEqualToSize(rounded.size, image.size)) return false;
    UIImage *composed = [image drawImage:rounded inRect:CGRectMake(0, 0, 10, 10)];
    return composed && CGSizeEqualToSize(composed.size, image.size);
}

bool MangoToolsScopeExitOrderWorks(void) {
    NSMutableArray<NSNumber *> *order = [NSMutableArray array];
    {
        @onExit { [order addObject:@1]; };
        @onExit { [order addObject:@2]; };
    }
    return [order isEqualToArray:@[@2, @1]];
}
