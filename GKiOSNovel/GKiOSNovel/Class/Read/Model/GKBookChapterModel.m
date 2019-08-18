//
//  GKBookChapterModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookChapterModel.h"
#import "BaseNetCache.h"
@implementation GKBookChapterModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"_id":@[@"id",@"_id"]};
}
- (GKBookContentModel *)bookContent{
    GKBookContentModel *model = [BaseNetCache objectForKey:self.link];
    if ([model isKindOfClass:GKBookContentModel.class]) {
        [model setContentPage];
        return model;
    }
    return nil;
}
@end

@implementation GKBookChapterInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"chapters" : GKBookChapterModel.class
             };
}

@end
