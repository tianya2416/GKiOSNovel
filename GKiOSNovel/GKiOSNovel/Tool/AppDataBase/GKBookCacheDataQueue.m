//
//  GKBookCacheDataQueue.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookCacheDataQueue.h"

@implementation GKBookCacheDataQueue
+ (void)insertDataToDataBase:(NSString *)bookId
                       model:(GKBookContentModel *)model
                  completion:(void(^)(BOOL success))completion{
    NSString *table = [NSString stringWithFormat:@"book(%@)",bookId?:@""];
    [BaseDataQueue insertDataToDataBase:table primaryId:@"contentId" userInfo:[model modelToJSONObject] completion:completion];
}
+ (void)insertDatasDataBase:(NSString *)bookId
                   listData:(NSArray <GKBookContentModel*>*)listData
                 completion:(void(^)(BOOL success))completion{
    NSString *table = [NSString stringWithFormat:@"book(%@)",bookId?:@""];
    [BaseDataQueue insertDatasDataBase:table primaryId:@"contentId" listData:[listData modelToJSONObject] completion:completion];
}
+ (void)getDataFromDataBase:(NSString *)bookId
                  contentId:(NSString *)contentId
                 completion:(void(^)(GKBookContentModel *bookModel))completion{
    NSString *table = [NSString stringWithFormat:@"book(%@)",bookId?:@""];
    [BaseDataQueue getDataFromDataBase:table primaryId:@"contentId" primaryValue:contentId completion:^(NSDictionary * _Nonnull dictionary) {
        GKBookContentModel *model = [GKBookContentModel modelWithJSON:dictionary];
        !completion ?: completion(model);
    }];
}
+ (void)getDatasFromDataBase:(NSString *)bookId
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKBookContentModel *>*listData))completion{
    NSString *table = [NSString stringWithFormat:@"book(%@)",bookId?:@""];
    [BaseDataQueue getDatasFromDataBase:table primaryId:@"contentId" page:page pageSize:pageSize completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKBookContentModel.class json:listData];
        !completion ?: completion(datas);
    }];
}
+ (void)dropTableFromDataBase:(NSString *)bookId completion:(void (^)(BOOL))completion{
    NSString *table = [NSString stringWithFormat:@"book(%@)",bookId?:@""];
    [BaseDataQueue dropTableDataBase:table completion:completion];
}
@end
