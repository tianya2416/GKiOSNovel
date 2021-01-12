//
//  BaseRefreshController.m
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"

NSString *loadTitle  = @"Data loading...";
NSString *errorData = @"icon_net_error";
@interface BaseRefreshController (){
    NSString *emptyData;
    NSString *emptyTitle;
    NSString *errorTitle;
}
@property (nonatomic, strong) NSMutableArray *images;
@property (strong, nonatomic) ATRefreshData *refreshData;
@end

@implementation BaseRefreshController
- (ATRefreshData *)refreshData{
    if (!_refreshData) {
        _refreshData = [[ATRefreshData alloc] init];
        _refreshData.dataSource = self;
        _refreshData.delegate = self;
    }
    return _refreshData;
}
- (void)dealloc {
    NSLog(@"%@", NSStringFromClass(self.class));
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option{
    [self setupRefresh:scrollView option:option image:@"icon_data_empty" title:@"Data Empty..."];
}
- (void)setupRefresh:(UIScrollView *)scrollView
              option:(ATRefreshOption)option
               image:(NSString *)image
               title:(NSString *)title{
    emptyTitle = title;
    emptyData = image;
    if ([self.refreshData respondsToSelector:@selector(setupRefresh:option:)]) {
        [self.refreshData setupRefresh:scrollView option:option];
    }
}
- (void)endRefresh:(BOOL)hasMore{
    if ([self.refreshData respondsToSelector:@selector(endRefresh:)]) {
        [self.refreshData endRefresh:hasMore];
    }
}
- (void)endRefreshFailure{
    [self endRefreshFailure:@"Net Error..."];
}
- (void)endRefreshFailure:(NSString *)error{
    errorTitle = error;
    if ([self.refreshData respondsToSelector:@selector(endRefreshFailure)]) {
        [self.refreshData endRefreshFailure];
    }
}
#pragma mark ATRefreshDelegate
- (void)refreshData:(NSInteger)page {
    
}
#pragma mark ATRefreshDataSource
- (NSArray <UIImage *>*)refreshHeaderData{
    return self.images;
}
- (NSArray <UIImage *>*)refreshFooterData{
    return self.images;
}
- (UIImage *)refreshLogoData{
    return self.refreshData.refreshing ? [UIImage imageNamed:@"icon_load_data"] : [UIImage imageNamed:[self refreshNetAvailable]? emptyData:errorData];
}
- (NSAttributedString *)refreshTitle{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = self.refreshData.refreshing ? loadTitle : ([self refreshNetAvailable] ? emptyTitle : errorTitle);
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName :[ATRefresh colorWithRGB:0X999999],
                                 NSParagraphStyleAttributeName : paragraph};
    return [[NSMutableAttributedString alloc] initWithString:text
                                                  attributes:attributes];
}
- (CAAnimation *)refreshAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}
- (CGFloat)refreshLogoSpace{
    return 10;
}
- (CGFloat)refreshLogoVertica{
    return  - NAVI_BAR_HIGHT/2;
}
- (UIColor *)refreshColor{
    return  [UIColor whiteColor];
}
- (NSAttributedString *)refreshSubtitle{
    return nil;
}
- (UIButton *)refreshButton{
    return nil;
}
@end
