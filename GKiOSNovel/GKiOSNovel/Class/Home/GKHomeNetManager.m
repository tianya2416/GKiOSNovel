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
        obj.rankSort = idx;
        dispatch_group_enter(group);
        [GKNovelNetManager homeHot:obj._id success:^(id  _Nonnull object) {
            GKBookInfo *info= [GKBookInfo modelWithJSON:object];
            if (info) {
                info.bookSort = obj.rankSort;
                [arrayDatas addObject:info];
            }
            dispatch_group_leave(group);
        } failure:^(NSString * _Nonnull error) {
            dispatch_group_leave(group);
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (arrayDatas.count) {
            
            dispatch_group_t groupQueue = dispatch_group_create();
            dispatch_group_enter(groupQueue);
            __block GKBookInfo *bookCase = nil;
            [GKBookCaseDataQueue getDatasFromDataBase:^(NSArray<GKBookDetailModel *> * _Nonnull listData) {
                bookCase = [[GKBookInfo alloc] init];
                bookCase.shortTitle = @"我的书架";
                bookCase.listData = listData;
                dispatch_group_leave(groupQueue);
            }];
            dispatch_group_notify(groupQueue, dispatch_get_main_queue(), ^{
                NSMutableArray *datas = [GKHomeNetManager sortedArrayUsingComparator:arrayDatas key:@"bookSort" ascending:YES].mutableCopy;
                if (bookCase.listData.count > 0) {
                    [datas insertObject:bookCase atIndex:0];
                }
                !success ?: success(datas.copy);
            });
//            [GKBookReadDataQueue getDatasFromDataBase:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
//
//            }];
        }else{
            !failure ?:failure(@"");
        }
    });
}
+ (NSArray *)sortedArrayUsingComparator:(NSArray <GKBookInfo *>*)listData key:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key?:@"bookSort" ascending:ascending];
    return [listData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
@end
