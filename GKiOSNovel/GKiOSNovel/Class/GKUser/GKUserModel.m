//
//  GKUserModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKUserModel.h"

@implementation GKUserModel
+ (instancetype)vcWithState:(GKUserState )state rankDatas:(NSArray *)rankDatas;{
    GKUserModel *vc = [[[self class] alloc] init];
    vc.state = state;
    vc.rankDatas = rankDatas;
    return vc;
}
@end
