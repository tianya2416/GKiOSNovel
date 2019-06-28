//
//  GKShareViewController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseViewController.h"
#import "GKBookListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKShareViewController : BaseConnectionController
+ (instancetype)vcWithBookModel:(GKBookDetailModel *)model;
+ (instancetype)vcWithBookListModel:(GKBookListDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
