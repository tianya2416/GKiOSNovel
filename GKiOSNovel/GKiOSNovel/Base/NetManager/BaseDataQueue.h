//
//  BaseDataQueue.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseDataQueue : NSObject

@property(strong, nonatomic,readonly)FMDatabaseQueue *dataQueue;
/**
 *  @brief 单利
 */
+ (instancetype )shareInstance;
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <NSDictionary *>*)listData
                 completion:(void(^)(BOOL success))completion;
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                primaryValue:(NSString *)primaryValue
                  completion:(void(^)(BOOL success))completion;
+ (void)deleteDatasToDataBase:(NSString *)tableName
                    primaryId:(NSString *)primaryId
                     listData:(NSArray <NSDictionary *>*)listData
                   completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDataFromDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
               primaryValue:(NSString *)primaryValue
                 completion:(void(^)(NSDictionary *dictionary))completion;
+ (void)getDatasFromDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                  completion:(void(^)(NSArray <NSDictionary *>*listData))completion;
+ (void)getDatasFromDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <NSDictionary *>*listData))completion;
/**
 *  @brief 删除表 
 */
+ (void)dropTableDataBase:(NSString *)tableName
               completion:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
