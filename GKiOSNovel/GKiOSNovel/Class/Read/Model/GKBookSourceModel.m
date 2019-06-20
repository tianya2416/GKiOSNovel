//
//  GKBookSourceModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookSourceModel.h"

@implementation GKBookSourceModel

@end

@implementation GKBookSourceInfo
- (NSString *)bookSourceId{
    return self.listData.firstObject._id ?:@"";
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"listData" : GKBookSourceModel.class
             };
}
@end
