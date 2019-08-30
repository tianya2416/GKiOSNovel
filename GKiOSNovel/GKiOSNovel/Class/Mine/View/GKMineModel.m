//
//  GKMineModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/8/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMineModel.h"

@implementation GKMineModel
+ (instancetype)vcWithTitle:(NSString *)title subTitle:(NSString *)subTitle iCon:(NSString *)iCon{
    GKMineModel *model = [[GKMineModel alloc] init];
    model.title = title;
    model.subTitle = subTitle;
    model.iCon = iCon;
    return model;
}
@end
