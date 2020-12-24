//
//  BaseRefreshController.h
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseViewController.h"
#import <ATRefresh_ObjectC.h>
#import <ATRefreshData.h>
@interface BaseRefreshController : BaseViewController<ATRefreshDataSource,ATRefreshDelegate>
@property (strong, nonatomic,readonly) ATRefreshData *refreshData;
//default
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option;
//custom
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option image:(NSString *)image title:(NSString *)title;
- (void)endRefresh:(BOOL)hasMore;

- (void)endRefreshFailure;
- (void)endRefreshFailure:(NSString *)error;

@end
