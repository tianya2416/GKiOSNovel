//
//  BaseRefreshController.h
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <YYKit.h>
#import <KVOController.h>
/**
 *  集成刷新控件
 */
typedef NS_ENUM(NSUInteger, ATRefreshOption) {
    ATRefreshNone = 0,
    ATHeaderRefresh = 1 << 0,
    ATFooterRefresh = 1 << 1,
    ATHeaderAutoRefresh = 1 << 2,
    ATFooterAutoRefresh = 1 << 3,
    ATFooterDefaultHidden = 1 << 4,
    ATRefreshDefault = (ATHeaderRefresh | ATHeaderAutoRefresh | ATFooterRefresh | ATFooterDefaultHidden),
};

static NSString *FDMSG_Home_DataRefresh                      = @"数据加载中...";
static NSString *FDMSG_Home_DataEmpty                        = @"数据空空如也...";
static NSString *FDNoNetworkMsg                              = @"无网络连接,请检查网络设置";

@interface BaseRefreshController : BaseViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) BOOL isRefreshing;
@property (nonatomic, assign, readonly) BOOL reachable;
/**
 @brief 设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
 @param scrollView 刷新控件所在scrollView
 @param option 刷新空间样式
 */
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option;
/**
 设置空界面显示, 如果需要定制化 请实现协议 DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
 tableView或者CollectionView数据reload后, 空界面展示可自动触发, 如需强制刷新, 请调用 [scrollView reloadEmptyDataSet];
 
 @param scrollView 空界面所在scrollView
 @param image 空界面图片
 @param title 空界面标题
 */
- (void)setupEmpty:(UIScrollView *)scrollView image:(UIImage *)image title:(NSString *)title;
- (void)setupEmpty:(UIScrollView *)scrollView;
/**
 @brief 分页请求一开始page = 1
 @param page 当前页码
 */
- (void)refreshData:(NSInteger)page;
/**
 @brief 分页加载成功 是否有下一页数据
 */
- (void)endRefresh:(BOOL)hasMore;
- (void)endRefreshNeedHidden:(BOOL)hasMore;
/**
 @brief 加载失败调用该方法
 */
- (void)endRefreshFailure;

- (void)headerRefreshing NS_REQUIRES_SUPER;
- (void)footerRefreshing NS_REQUIRES_SUPER;
- (void)scroolToTopBeginRefresh;

@end
