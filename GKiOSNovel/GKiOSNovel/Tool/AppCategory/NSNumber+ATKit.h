//
//  NSNumber+ATKit.h
//  Postre
//
//  Created by CoderLT on 2017/7/9.
//  Copyright © 2017年 CoderLT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumberFormatter (ATKit)
- (NSString *)decimalStringWithNumber:(NSNumber *)number;
- (NSString *)moneyStringWithNumber:(NSNumber *)number;
@end

@interface NSNumber (ATKit)
- (NSString *)decimalString;
- (NSString *)nonZeroDecimalString;
- (NSString *)moneyString;
@end

@interface NSString (money)
- (NSString *)moneyTrim;
@end
