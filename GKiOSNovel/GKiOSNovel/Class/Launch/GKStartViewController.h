//
//  GKStartViewController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKStartViewController : BaseConnectionController
+ (instancetype)vcWithCompletion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
