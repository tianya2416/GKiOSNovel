//
//  GKBookCaseDataQueue.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookCaseDataQueue.h"
static NSString *table = @"bookCase";
static NSString *primaryId = @"_id";
@implementation GKBookCaseDataQueue
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKBookDetailModel *)bookModel
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue insertDataToDataBase:table primaryId:primaryId userInfo:[bookModel modelToJSONObject] completion:completion];
}
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <GKBookDetailModel *>*)listData
                 completion:(void(^)(BOOL success))completion{
    [BaseDataQueue insertDatasDataBase:table primaryId:primaryId listData:[listData modelToJSONObject] completion:completion];
}
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(GKBookDetailModel *)bookModel
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue updateDataToDataBase:table primaryId:primaryId userInfo:[bookModel modelToJSONObject] completion:completion];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)bookId
                  completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:table primaryId:primaryId primaryValue:bookId completion:completion];
    
}
+ (void)deleteDatasToDataBase:(NSArray <GKBookDetailModel *>*)listData
                   completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDatasToDataBase:table primaryId:primaryId listData:[listData modelToJSONObject] completion:completion];
}
/**
 *  @brief 获取数据
 */
+ (void)getDataFromDataBase:(NSString *)bookId
                 completion:(void(^)(GKBookDetailModel *bookModel))completion{
    [BaseDataQueue getDataFromDataBase:table primaryId:primaryId primaryValue:bookId completion:^(NSDictionary * _Nonnull dictionary) {
        GKBookDetailModel *model = [GKBookDetailModel modelWithJSON:dictionary];
        !completion ?: completion(model);
    }];
}
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKBookDetailModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:table primaryId:primaryId completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        !completion ?: completion([NSArray modelArrayWithClass:GKBookModel.class json:listData]);
    }];
}
+ (void)getDatasFromDataBase:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKBookDetailModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:table primaryId:primaryId page:page pageSize:pageSize completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        !completion ?: completion([NSArray modelArrayWithClass:GKBookModel.class json:listData]);
    }];
}
@end
