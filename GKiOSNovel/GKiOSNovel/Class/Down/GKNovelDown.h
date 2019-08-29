//
//  GKNovelDown.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKDownBookInfo.h"
@interface GKNovelDown : NSObject
@property (strong, nonatomic, readonly)GKDownBookInfo *downInfo;//当前正在下载的数据
@property (strong, nonatomic) NSMutableArray *downTasks;//数组中要下载的小说
@property (copy, nonatomic) void (^completion)(NSInteger index,NSInteger total,GKDownTaskState state);
+ (instancetype )shareInstance;
//下载数组是否有该本书
+ (BOOL)haveBookInfo:(GKDownBookInfo *)bookInfo;
/**
 @brief 添加到下载队列
 */
+ (void)addDownTask:(GKBookDetailModel *)model chapters:(NSArray *)chapters;

/**
 @brief 下载完后继续下载
 */
+ (void)startDown;
/**
 @brief 开始下载
 */
+ (void)start:(GKDownBookInfo *)bookInfo;
/**
 @brief 等待下载
 */
+ (void)wait:(GKDownBookInfo *)bookInfo;
/**
 @brief 暂停下载
 */
+ (void)pause:(GKDownBookInfo *)bookInfo;
/**
 @brief 删除下载
 */
+ (void)deletes:(GKDownBookInfo *)bookInfo;
/**
 @brief 完成下载
 */
+ (void)finish:(GKDownBookInfo *)bookInfo;
//
+ (NSArray *)waitDownDatas;
@end

