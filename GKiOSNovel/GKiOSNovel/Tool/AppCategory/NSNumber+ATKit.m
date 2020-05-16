//
//  NSNumber+ATKit.m
//  Postre
//
//  Created by CoderLT on 2017/7/9.
//  Copyright © 2017年 CoderLT. All rights reserved.
//

#import "NSNumber+ATKit.h"

@implementation NSNumber (ATKit)
- (NSString *)nonZeroDecimalString {
    return self.intValue == 0 ? nil : self.decimalString;
}
- (NSString *)decimalString {
    return [[NSNumberFormatter new] decimalStringWithNumber:self];
}
- (NSString *)moneyString {
    return [[NSNumberFormatter new] moneyStringWithNumber:self];
}
@end

@implementation NSNumberFormatter (ATKit)
- (NSString *)decimalStringWithNumber:(NSNumber *)number {
    double value = [number doubleValue];
    if (value > 10000) {
        return [NSString stringWithFormat:@"%.1f万", value/10000];
    }
    self.numberStyle = NSNumberFormatterDecimalStyle;
    self.locale = [NSLocale currentLocale];
    return [self stringFromNumber:number];
}
- (NSString *)moneyStringWithNumber:(NSNumber *)number {
    NSInteger val100 = round(number.doubleValue * 100);
    if (val100 % 100 == 0) {
        return [NSString stringWithFormat:@"%.0f", number.doubleValue];
    }
    else if (val100 % 10 == 0) {
        return [NSString stringWithFormat:@"%.1f", number.doubleValue];
    }
    else {
        return [NSString stringWithFormat:@"%.2f", number.doubleValue];
    }
}
@end

@implementation NSString (money)
- (NSString *)moneyTrim {
    return @(self.doubleValue).moneyString;
}
@end
