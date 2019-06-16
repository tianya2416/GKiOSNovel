//
//  GKBookCaseDataQueue.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKBookDetailModel.h"
#import "BaseDataQueue.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookCaseDataQueue : NSObject
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKBookDetailModel *)bookModel
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <GKBookDetailModel *>*)listData
                 completion:(void(^)(BOOL success))completion;

/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(GKBookDetailModel *)bookModel
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)bookId
                  completion:(void(^)(BOOL success))completion;
+ (void)deleteDatasToDataBase:(NSArray <GKBookDetailModel *>*)listData
                  completion:(void(^)(BOOL success))completion;

/**
 *  @brief 获取数据
 */
+ (void)getDataFromDataBase:(NSString *)bookId
                 completion:(void(^)(GKBookDetailModel *bookModel))completion;
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKBookDetailModel *>*listData))completion;
+ (void)getDatasFromDataBase:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKBookDetailModel *>*listData))completion;
@end

NS_ASSUME_NONNULL_END
