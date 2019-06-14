//
//  GKSearchDataQueue.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKSearchDataQueue : BaseDataQueue
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(NSString *)hotWord
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 数据删除
 */
+ (void)deleteDataToDataBase:(NSString *)hotWord
                  completion:(void(^)(BOOL success))completion;
+ (void)deleteDatasToDataBase:(NSArray *)listData
                   completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <NSString *>*listData))completion;

/**
 *  @brief 删除表 该方法慎用
 */
+ (void)dropTableDataBase:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
