//
//  GKBookDetailController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailController : BaseConnectionController
+ (instancetype)vcWithBookId:(NSString *)bookId;
@end

NS_ASSUME_NONNULL_END
