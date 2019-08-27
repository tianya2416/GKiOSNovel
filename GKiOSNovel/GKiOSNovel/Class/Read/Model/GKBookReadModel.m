//
//  GKBookReadModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookReadModel.h"

@implementation GKBookReadModel
- (void)setUpdateTime:(NSString *)updateTime{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if (updateTime.length == 0) {
        _updateTime = timeSp;
    }else {
        _updateTime = updateTime;
    }
}
@end
