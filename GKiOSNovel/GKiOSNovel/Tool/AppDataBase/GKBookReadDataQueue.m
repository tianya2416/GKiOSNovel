//
//  GKBookReadDataQueue.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookReadDataQueue.h"
static NSString *tableBook = @"bookRead";
static NSString *primaryBookId = @"bookId";
@implementation GKBookReadDataQueue
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKBookReadModel *)bookModel
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue insertDataToDataBase:tableBook primaryId:primaryBookId userInfo:[bookModel modelToJSONObject] completion:^(BOOL success) {
        success ? [GKUserManager reloadHomeData:GKLoadDataDataBase] : nil;
        !completion ?:completion(success);
    }];
}
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <GKBookReadModel *>*)listData
                 completion:(void(^)(BOOL success))completion{
    [BaseDataQueue insertDatasDataBase:tableBook primaryId:primaryBookId listData:[listData modelToJSONObject] completion:^(BOOL success) {
        success ? [GKUserManager reloadHomeData:GKLoadDataDataBase] : nil;
        !completion ?:completion(success);
    }];
}
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(GKBookReadModel *)bookModel
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue updateDataToDataBase:tableBook primaryId:primaryBookId userInfo:[bookModel modelToJSONObject] completion:^(BOOL success) {
        success ? [GKUserManager reloadHomeData:GKLoadDataDataBase] : nil;
        !completion ?:completion(success);
    }];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)bookId
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:tableBook primaryId:primaryBookId primaryValue:bookId completion:^(BOOL success) {
        success ? [GKUserManager reloadHomeData:GKLoadDataDataBase] : nil;
        !completion ?:completion(success);
    }];
    
}
+ (void)deleteDatasToDataBase:(NSArray <GKBookReadModel *>*)listData
                   completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDatasToDataBase:tableBook primaryId:primaryBookId listData:[listData modelToJSONObject] completion:^(BOOL success) {
        success ? [GKUserManager reloadHomeData:GKLoadDataDataBase] : nil;
        !completion ?:completion(success);
    }];
}
/**
 *  @brief 获取数据
 */
+ (void)getDataFromDataBase:(NSString *)bookId
                 completion:(void(^)(GKBookReadModel *bookModel))completion{
    [BaseDataQueue getDataFromDataBase:tableBook primaryId:primaryBookId primaryValue:bookId completion:^(NSDictionary * _Nonnull dictionary) {
        GKBookReadModel *model = [GKBookReadModel modelWithJSON:dictionary];
        !completion ?: completion(model);
    }];
}
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKBookReadModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:tableBook primaryId:primaryBookId completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKBookReadModel.class json:listData];
        datas = [GKBookReadDataQueue sortedArrayUsingComparator:datas key:@"updateTime" ascending:NO];
        !completion ?: completion(datas);
    }];
}
+ (void)getDatasFromDataBase:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKBookReadModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:tableBook primaryId:primaryBookId page:page pageSize:pageSize completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKBookReadModel.class json:listData];
        datas = [GKBookReadDataQueue sortedArrayUsingComparator:datas key:@"updateTime" ascending:NO];
        !completion ?: completion(datas);
    }];
}
+ (NSArray *)sortedArrayUsingComparator:(NSArray <GKBookReadModel *>*)listData key:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key?:@"bookId" ascending:ascending];
    return [listData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
@end
