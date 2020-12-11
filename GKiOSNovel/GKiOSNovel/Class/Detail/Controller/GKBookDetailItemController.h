//
//  GKChapterController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailItemController : BaseTableViewController
+ (instancetype)vcWithBookId:(NSString *)bookId;
@property (strong, nonatomic)GKBookDetailModel *model;
@end
@interface GKBookDetailRecomController : BaseConnectionController
+ (instancetype)vcWithBookId:(NSString *)bookId;
@end

@interface GKBookListRecomController : BaseConnectionController
+ (instancetype)vcWithBookId:(NSString *)bookId;
@end
NS_ASSUME_NONNULL_END
