//
//  GKDownDataQueue.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownDataQueue.h"
static NSString *tableBrowse = @"downBook";
static NSString *tableId = @"bookId";
@implementation GKDownDataQueue
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKDownBookInfo *)bookModel
                  completion:(void(^)(BOOL success))completion{
    [GKDownDataQueue insertDataToDataBase:tableBrowse primaryId:tableId userInfo:[bookModel modelToJSONObject] completion:completion];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)bookId
                  completion:(void(^)(BOOL success))completion{
    [GKDownDataQueue deleteDataToDataBase:tableBrowse primaryId:tableId primaryValue:bookId completion:completion];
}

/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKDownBookInfo *>*listData))completion{
    [GKDownDataQueue getDatasFromDataBase:tableBrowse primaryId:tableId page:page pageSize:pageSize completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKDownBookInfo.class json:listData];
        !completion ?: completion([GKDownDataQueue sortedArrayUsingComparator:datas key:@"updateTime" ascending:NO]);
    }];
}
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKDownBookInfo *>*listData))completion{
    [GKDownDataQueue getDatasFromDataBase:tableBrowse primaryId:tableId completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKDownBookInfo.class json:listData];
        !completion ?: completion([GKDownDataQueue sortedArrayUsingComparator:datas key:@"updateTime" ascending:NO]);
    }];
}
+ (void)getDatasFinish:(void (^)(NSArray<GKDownBookInfo *> * _Nonnull))completion{
    [GKDownDataQueue getDatasFromDataBase:^(NSArray<GKDownBookInfo *> * _Nonnull listData) {
        NSMutableArray *arrayData = [[NSMutableArray alloc] init];
        [listData enumerateObjectsUsingBlock:^(GKDownBookInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.state == GKDownTaskFinish) {
                [arrayData addObject:obj];
            }
        }];
        !completion ?: completion(arrayData);
    }];
}
+ (void)getDatasUnFinish:(void (^)(NSArray<GKDownBookInfo *> * _Nonnull))completion{
    [GKDownDataQueue getDatasFromDataBase:^(NSArray<GKDownBookInfo *> * _Nonnull listData) {
        NSMutableArray *arrayData = [[NSMutableArray alloc] init];
        [listData enumerateObjectsUsingBlock:^(GKDownBookInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.state != GKDownTaskFinish) {
                [arrayData addObject:obj];
            }
        }];
        !completion ?: completion([GKDownDataQueue sortedArrayUsingComparator:arrayData.copy key:@"updateTime" ascending:NO]);
    }];
}
+ (NSArray *)sortedArrayUsingComparator:(NSArray <GKDownBookInfo *>*)listData key:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key?:@"updateTime" ascending:ascending];
    return [listData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
+ (void)getDataFromDataBase:(NSString *)primaryId
                 completion:(void(^)(GKDownBookInfo *bookInfo))completion{
    [GKDownDataQueue getDataFromDataBase:tableBrowse primaryId:tableId primaryValue:primaryId completion:^(NSDictionary * _Nonnull dictionary) {
        GKDownBookInfo *info = [GKDownBookInfo modelWithJSON:dictionary];
        !completion ?: completion(info);
    }];
}
@end
