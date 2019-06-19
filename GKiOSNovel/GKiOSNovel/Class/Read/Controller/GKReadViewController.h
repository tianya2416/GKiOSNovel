//
//  GKReadViewController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKReadViewController : BaseViewController
@property (assign, nonatomic,readonly)NSInteger pageIndex;
@property (assign, nonatomic,readonly)NSInteger chapterIndex;
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title content:(NSAttributedString *)content;
@end

NS_ASSUME_NONNULL_END
