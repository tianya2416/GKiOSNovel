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
- (GKBookContentModel *)bookContent{
    if (!_bookContent) {
        _bookContent = [BaseNetCache memoryObjectForKey:self.chapterId];
        if ([_bookContent isKindOfClass:GKBookContentModel.class]) {
            [_bookContent setContentPage];
        }
    }
    return _bookContent;
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"chapterId":@[@"chapterId",@"id"]};
}

@end

@implementation GKBookChapterInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"chapters" : GKBookChapterModel.class
             };
}

@end
