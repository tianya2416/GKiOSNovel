//
//  GKRankModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKRankModel : BaseModel

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *collapse;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *monthRank;
@property (copy, nonatomic) NSString *shortTitle;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *totalRank;

@property (assign, nonatomic) BOOL select;
@property (assign, nonatomic) NSInteger rankSort;//用来排序
@end

@interface GKRankInfo : BaseModel

@property (assign, nonatomic) GKUserState state;
@property (strong, nonatomic) NSArray <GKRankModel *>*listBoys;
@property (strong, nonatomic) NSArray <GKRankModel *>*listGirls;
@property (strong, nonatomic) NSArray <GKRankModel *>*picture;
@property (strong, nonatomic) NSArray <GKRankModel *>*epub;

@property (strong, nonatomic) NSArray <GKRankModel *>*listData;

@end
NS_ASSUME_NONNULL_END
