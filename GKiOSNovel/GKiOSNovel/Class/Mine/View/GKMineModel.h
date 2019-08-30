//
//  GKMineModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/8/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKMineModel : BaseModel
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *iCon;
+ (instancetype)vcWithTitle:(NSString *)title subTitle:(NSString *)subTitle iCon:(NSString *)iCon;
@end

NS_ASSUME_NONNULL_END
