//
//  GKHomeNetManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeNetManager.h"

@implementation GKHomeNetManager
+ (void)homeNet:(NSArray <GKRankModel *>*)listData success:(void(^)(NSArray <GKBookInfo *>*datas))success failure:(void(^)(NSString *error))failure{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray <GKBookInfo *>*arrayDatas = [[NSMutableArray alloc] init];
    [listData enumerateObjectsUsingBlock:^(GKRankModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        [GKNovelNetManager homeHot:obj._id success:^(id  _Nonnull object) {
            GKBookInfo *info= [GKBookInfo modelWithJSON:object];
            if (info) {
                [arrayDatas addObject:info];
            }
            dispatch_group_leave(group);
        } failure:^(NSString * _Nonnull error) {
            dispatch_group_leave(group);
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (arrayDatas.count) {
            !success ?: success(arrayDatas);
        }else{
            !failure ?: failure(@"网络问题");
        }
    });
}
@end
