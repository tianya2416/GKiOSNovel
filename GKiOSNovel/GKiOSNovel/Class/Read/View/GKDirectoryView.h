//
//  GKDirectoryView.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
NS_ASSUME_NONNULL_BEGIN
@class GKDirectoryView;
@protocol GKDirectoryDelegate <NSObject>
@optional
- (void)directoryView:(GKDirectoryView *__nullable)setView chapter:(NSInteger)chapter;
@end
@interface GKDirectoryView : BaseTableView

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) GKBookChapterModel *model;
@property (assign, nonatomic) id<GKDirectoryDelegate>delegate;
- (void)show;
@end

NS_ASSUME_NONNULL_END
