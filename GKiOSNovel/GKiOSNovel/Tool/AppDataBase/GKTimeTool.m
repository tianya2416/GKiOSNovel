//
//  GKTimeTool.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKTimeTool.h"

@implementation GKTimeTool
+ (NSString *)timeStampTurnToTimesType:(NSString *)timesTamp
{
    NSTimeInterval interval    = [timesTamp doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
@end
