//
//  GKBookChapterController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookChapterController : BaseTableViewController
@property (strong, nonatomic)GKBookModel *model;
+ (instancetype)vcWithChapter:(NSString *)bookSourceId;
@end
@interface GKBookSourceController : BaseTableViewController
+ (instancetype)vcWithChapter:(NSString *)bookId sourceId:(NSString *)sourceId completion:(void (^)(NSInteger index))completion;
@end
NS_ASSUME_NONNULL_END
