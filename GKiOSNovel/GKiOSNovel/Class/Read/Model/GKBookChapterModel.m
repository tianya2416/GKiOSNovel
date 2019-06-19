//
//  GKBookChapterModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookChapterModel.h"

@implementation GKBookChapterModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"_id":@[@"id",@"_id"]};
}
@end

@implementation GKBookChapterInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"chapters" : GKBookChapterModel.class
             };
}
@end
