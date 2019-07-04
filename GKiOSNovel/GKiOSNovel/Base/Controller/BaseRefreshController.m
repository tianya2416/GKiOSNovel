//
//  BaseRefreshController.m
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"
#define defaultDataEmpty [UIImage imageNamed:@"icon_data_empty"]//空数据图片
#define defaultDataLoad [UIImage imageNamed:@"icon_data_load"]//
#define defaultNetError [UIImage imageNamed:@"icon_net_error"]//无网络图片
@interface BaseRefreshController () {
    BOOL _isSetKVO;
    BOOL _needReload;
    __weak UIView *_emptyView;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSDate *lastRefreshDate;
@property (nonatomic, copy) NSString *emptyTitle;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, strong) UIImage *loadImage;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL reachable;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation BaseRefreshController
- (void)dealloc {
    _scrollView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - refresh 刷新处理
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option {
    self.scrollView = scrollView;
    if (option == ATRefreshNone) {
        if ([self respondsToSelector:@selector(headerRefreshing)]) {
            [self headerRefreshing];
        }
        return;
    }
    if (option & ATHeaderRefresh) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        if (self.images.count > 0) {
            [header setImages:@[self.images.firstObject] forState:MJRefreshStateIdle];
            [header setImages:self.images duration:0.4f forState:MJRefreshStateRefreshing];
        }
        
        if (option & ATHeaderAutoRefresh) {
            [self headerRefreshing];
        }
        scrollView.mj_header = header;
    }
    
    if (option & ATFooterRefresh) {
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
        footer.triggerAutomaticallyRefreshPercent = -20.0f;
        footer.stateLabel.hidden = NO;
        footer.labelLeftInset = -22;
    
        if (self.images.count > 0) {
            [footer setImages:@[self.images[0]] forState:MJRefreshStateIdle];
            [footer setImages:self.images duration:0.40f forState:MJRefreshStateRefreshing];
        }
        [footer setTitle:@"--我是有底线的--" forState:MJRefreshStateNoMoreData];
        [footer setTitle:@"" forState:MJRefreshStatePulling];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        
        
        if (option & ATFooterAutoRefresh) {
            if (self.currentPage == 0) {
                self.isRefreshing = YES;
            }
            [self footerRefreshing];
        }
        else if (option & ATFooterDefaultHidden) {
            footer.hidden = YES;
        }
        scrollView.mj_footer = footer;
    }
}
- (void)scroolToTopBeginRefresh {
    if (!self.scrollView.mj_header.isRefreshing) {
        [self.scrollView.mj_header beginRefreshing];
        dispatch_async_on_main_queue(^{
            [self.scrollView scrollToTopAnimated:NO];
        });
    }
}
- (void)headerRefreshing {
    self.isRefreshing = YES;
    self.scrollView.mj_footer.hidden = YES;
    self.currentPage = RefreshPageStart;
    [self refreshData:self.currentPage];
    self.lastRefreshDate = [NSDate date];
}

- (void)footerRefreshing {
    self.currentPage++;
    [self refreshData:self.currentPage];
}

- (void)endRefreshFailure {
    if (self.currentPage > RefreshPageStart) {
        self.currentPage--;
    }
    [self baseEndRefreshing];
    if (self.scrollView.mj_footer.isRefreshing) {
        self.scrollView.mj_footer.state = MJRefreshStateIdle;
    }
}
- (void)baseEndRefreshing {
    if (self.scrollView.mj_header.isRefreshing) {
        [self.scrollView.mj_header endRefreshing];
    }
    self.isRefreshing = NO;
}
- (void)endRefresh:(BOOL)hasMore {
    [self baseEndRefreshing];
    
    if (hasMore) {
        self.scrollView.mj_footer.state = MJRefreshStateIdle;
        ((MJRefreshAutoStateFooter *)self.scrollView.mj_footer).stateLabel.textColor = [UIColor colorWithRGB:0x666666];
        self.scrollView.mj_footer.hidden = NO;
    }
    else {
        self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        ((MJRefreshAutoStateFooter *)self.scrollView.mj_footer).stateLabel.textColor = [UIColor colorWithRGB:0x999999];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.scrollView.mj_footer.hidden = (self.currentPage == RefreshPageStart) || (self.scrollView.contentSize.height < self.scrollView.height);
        });
    }
}
- (void)endRefreshNeedHidden:(BOOL)hasMore {
    [self baseEndRefreshing];
    
    self.scrollView.mj_footer.state = hasMore ? MJRefreshStateIdle : MJRefreshStateNoMoreData;
    self.scrollView.mj_footer.hidden = !hasMore;
}

- (void)refreshData:(NSInteger)page {
    self.currentPage = page;
    
    if ([self.className isEqualToString:[BaseRefreshController className]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.scrollView.mj_header.isRefreshing || self.scrollView.mj_footer.isRefreshing) {
                [self endRefreshFailure];
            }
        });
    }
}

- (void)setIsRefreshing:(BOOL)isRefreshing {
    _isRefreshing = isRefreshing;
    
    if (self.scrollView.emptyDataSetVisible) {
        [self.scrollView reloadEmptyDataSet];
    }
}


#pragma mark - DZNEmptyData 空数据界面处理
- (void)setupEmpty:(UIScrollView *)scrollView {
    [self setupEmpty:scrollView image:defaultDataEmpty title:FDMSG_Home_DataEmpty];
}
- (void)setupEmpty:(UIScrollView *)scrollView image:(UIImage *)image title:(NSString *)title {
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
    self.emptyImage = image;
    self.emptyTitle = title;
    
    if (_isSetKVO) {
        return;
    }
    _isSetKVO = YES;
    [self.KVOController observe:scrollView keyPaths:@[FBKVOKeyPath(scrollView.contentSize), FBKVOKeyPath(scrollView.contentInset)] options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, UIScrollView * _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object.contentOffset.y >= -object.mj_inset.top && object.emptyDataSetVisible) {
            [NSObject cancelPreviousPerformRequestsWithTarget:object selector:@selector(reloadEmptyDataSet) object:nil];
            [object performSelector:@selector(reloadEmptyDataSet) afterDelay:0.01f];
        }
    }];
}
#pragma mark DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = self.isRefreshing ? FDMSG_Home_DataRefresh : self.emptyTitle;
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName :Appx999999,
                                 NSParagraphStyleAttributeName : paragraph};
    if (![self reachable]) {
        text = FDNoNetworkMsg;
    }
    return [[NSMutableAttributedString alloc] initWithString:(text ? [NSString stringWithFormat:@"\r\n%@", text] : @"")
                                                  attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage *imageEmpty = self.isRefreshing ? self.loadImage : self.emptyImage;
    return self.reachable ?imageEmpty : defaultNetError;
}

#pragma mark - DZNEmptyDataSetDelegate

// 是否可以动画显示
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    
    return NO;//self.isRefreshing;
}
// 给图片添加动画
//- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *) scrollView{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
//    animation.duration = 0.2;
//    animation.cumulative = YES;
//    animation.repeatCount = MAXFLOAT;
//
//    return animation;
//}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -NAVI_BAR_HIGHT/2;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 1;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return !self.isRefreshing;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (!self.isRefreshing) {
        [self headerRefreshing];
    }
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}
- (BOOL)reachable{
     return  [YYReachability reachability].status != YYReachabilityStatusNone;
}
- (UIImage *)loadImage{
    if (!_loadImage) {
        _loadImage = [UIImage animatedImageWithImages:self.images.copy duration:0.4];
    }
    return _loadImage;
}
- (NSMutableArray *)images{
    if (!_images) {
        _images = @[].mutableCopy;
        for (int i = 1; i <= 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%@", @(i+1)]];
            if (!image) {
                break;
            }
            [_images addObject:image];
        }
        for (int i = 4; i > 0; i--) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%@", @(i+1)]];
            if (!image) {
                break;
            }
            [_images addObject:image];
        }
    }
    return _images;
}

@end
