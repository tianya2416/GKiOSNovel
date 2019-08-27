//
//  GKDownDataQueue.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"
#import "GKDownBookInfo.h"


@interface GKDownDataQueue : BaseDataQueue
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKDownBookInfo *)bookModel
                  completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)primaryId
                  completion:(void(^)(BOOL success))completion;

/**
 *  @brief 获取数据
 */
+ (void)getDatasFinish:(void(^)(NSArray <GKDownBookInfo *>*listData))completion;
+ (void)getDatasUnFinish:(void(^)(NSArray <GKDownBookInfo *>*listData))completion;
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKDownBookInfo *>*listData))completion;
+ (void)getDataFromDataBase:(NSString *)primaryId
                 completion:(void(^)(GKDownBookInfo *bookInfo))completion;

@end


