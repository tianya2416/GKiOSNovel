//
//  GKReadContentController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKReadContentController : BaseViewController
+ (instancetype)vcWithBookDetailModel:(GKBookDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
