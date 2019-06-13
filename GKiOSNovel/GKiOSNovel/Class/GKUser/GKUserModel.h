//
//  GKUserModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKRankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKUserModel : BaseModel
@property (assign, nonatomic) GKUserState state;
@property (strong, nonatomic) NSArray <GKRankModel *>*rankDatas;//用户的爱好

+ (instancetype)vcWithState:(GKUserState )state rankDatas:(NSArray *)rankDatas;
@end

NS_ASSUME_NONNULL_END
