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
+ (instancetype )shareInstance;
/**
 @brief 添加到下载队列
 */
+ (void)addDownTask:(GKBookDetailModel *)bookInfo chapters:(NSArray <GKBookChapterModel *>*)chapters;

/**
 @brief 下载完后继续下载
 */
+ (void)startDown;
/**
 @brief 开始下载
 */
+ (void)start:(GKDownBookInfo *)bookInfo completion:(void(^)(NSInteger index,NSInteger total,GKDownTaskState state))completion;
/**
 @brief 暂停下载
 */
+ (void)pause:(GKDownBookInfo *)bookInfo;
/**
 @brief 删除下载
 */
+ (void)deletes:(GKDownBookInfo *)bookInfo;
@end

