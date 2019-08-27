//
//  GKDownBookInfo.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/8/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailModel.h"
typedef NS_ENUM(NSInteger, GKDownTaskState) {
    GKDownTaskDefault =  0,//等待中
    GKDownTaskLoading =  1,//下载中
    GKDownTaskPause   =  2,//暂停中
    GKDownTaskFinish  =  3,//下载完成
};
NS_ASSUME_NONNULL_BEGIN

@interface GKDownBookInfo : GKBookDetailModel

@property (assign, nonatomic) NSInteger downIndex;//下载到第几章
@property (strong, nonatomic) NSArray <GKBookChapterModel *>*chapters;
@property (assign, nonatomic) GKDownTaskState state;//下载状态

+ (instancetype)vcWithModel:(GKBookDetailModel *)bookInfo chapters:(NSArray *)chapters state:(GKDownTaskState )state;

@end

NS_ASSUME_NONNULL_END
