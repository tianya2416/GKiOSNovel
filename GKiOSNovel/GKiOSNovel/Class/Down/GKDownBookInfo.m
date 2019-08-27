//
//  GKDownBookInfo.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/8/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownBookInfo.h"

@implementation GKDownBookInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"chapters" : [GKBookChapterModel class]};
}
+ (instancetype)vcWithModel:(GKBookDetailModel *)bookInfo chapters:(nonnull NSArray *)chapters state:(GKDownTaskState)state{
    
    GKDownBookInfo *info = [GKDownBookInfo modelWithJSON:[bookInfo modelToJSONObject]];
    info.state = state;
    info.chapters = chapters;
    return info;
}
@end
