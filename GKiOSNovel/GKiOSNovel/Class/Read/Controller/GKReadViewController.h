//
//  GKReadViewController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol GKReadViewDelegate <NSObject>

- (void)viewDidAppear:(UIViewController *)ctrl animated:(BOOL)animated;

@end
@interface GKReadViewController : BaseViewController
@property (assign, nonatomic) id<GKReadViewDelegate>delegate;
@property (assign, nonatomic,readonly)NSInteger pageIndex;
@property (assign, nonatomic,readonly)NSInteger chapterIndex;
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title bookName:(NSString *)bookName content:(NSAttributedString *)content;
@end

NS_ASSUME_NONNULL_END
