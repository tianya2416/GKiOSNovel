//
//  GKSetViewManager.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKReadBottomView.h"
#import "GKReadTopView.h"
#import "GKReadSetView.h"
#import "GKMoreSetView.h"
#import "GKDirectoryView.h"
#import "GKBookContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKSetViewManager : UIView

@property (strong, nonatomic) GKMoreSetView *moreSetView;
@property (strong, nonatomic) GKReadSetView *setView;
@property (strong, nonatomic) GKReadBottomView *bottomView;
@property (strong, nonatomic) GKReadTopView *topView;
@property (strong, nonatomic) GKDirectoryView *directoryView;

@property (strong, nonatomic) UIButton *tapView;
@property (strong, nonatomic) UIView *botView;

@property (strong, nonatomic) GKBookContentModel *bookContent;
@property (strong, nonatomic) GKBookChapterModel *chapterModel;
@property (strong, nonatomic) GKBookChapterInfo *chapterInfo;
@property (strong, nonatomic) GKBookModel *bookModel;

- (void)tapAction;

@end

NS_ASSUME_NONNULL_END
