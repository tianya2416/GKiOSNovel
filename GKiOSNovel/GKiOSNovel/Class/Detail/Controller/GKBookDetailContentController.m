//
//  GKBookDetailContentController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKBookDetailContentController.h"
#import "GKShareViewController.h"
#import "GKBookDetailTabbar.h"
#import "GKBookDetailView.h"
#import "GKBookDetailCell.h"
#import "GKBookDetailItemController.h"
#import "GKBookChapterController.h"
#import "GKBookListDetailController.h"
#import "GKDetailNaviView.h"
@interface GKBookDetailContentController ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>
@property (strong, nonatomic) GKBookDetailTabbar *tabbar;
@property (strong, nonatomic) GKBookDetailView *detailView;
@property (strong, nonatomic) GKBookDetailCell *topView;
@property (strong, nonatomic) GKDetailNaviView *naviView;

@property (strong, nonatomic) GKBookDetailModel *model;
@property (copy, nonatomic) NSString *bookId;
@end

@implementation GKBookDetailContentController
+ (instancetype)vcWithConfig:(NSString *)bookId {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;// YNPageStyleSuspensionTopPause;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = YES;
    configration.showNavigation = NO;
    configration.scrollMenu = YES;
    configration.aligmentModeCenter = YES;
    configration.suspenOffsetY = NAVI_BAR_HIGHT;
    
    configration.menuHeight = 44;
    configration.itemMargin = 40;
    configration.lineColor = AppColor;
    configration.normalItemColor = Appx333333;
    configration.selectedItemColor = AppColor;
    configration.lineWidthEqualFontWidth = true;
    GKBookDetailContentController *vc = [GKBookDetailContentController pageViewControllerWithControllers:[self controllers:bookId]
                                                                                      titles:[self titles]
                                                                                      config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    vc.bookId = bookId;
    vc.headerView = vc.topView;
    return vc;
}
+ (NSArray *)controllers:(NSString *)bookId {
    return @[[GKBookDetailItemController vcWithBookId:bookId],[GKBookChapterController vcWithChapter:bookId],[GKBookDetailRecomController vcWithBookId:bookId],[GKBookListRecomController vcWithBookId:bookId]];
}
+ (NSArray *)titles {
    return  @[@"详情",@"章节",@"书籍",@"书单"];
}
- (void)setModel:(GKBookDetailModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.topView.model = _model;
    self.naviView.titleLab.text = _model.title;
    [self.controllersM enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:GKBookDetailItemController.class]) {
            GKBookDetailItemController *item = obj;
            item.model = _model;
        }else if ([obj isKindOfClass:GKBookChapterController.class]){
            GKBookChapterController *item = obj;
            item.model = _model;
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.naviView.superview);
            make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.naviView setAlphas:0];
    
    [self.view addSubview:self.tabbar];
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabbar.superview);
        make.height.offset(49);
        make.bottom.equalTo(self.tabbar.superview).offset(-TAB_BAR_ADDING);
    }];
}
- (void)reloadUI:(BOOL)reload{
    self.tabbar.collection = YES;
}
- (void)loadData{
    [GKBookCaseDataQueue getDataFromDataBase:self.bookId completion:^(GKBookDetailModel * _Nonnull bookModel) {
        if (bookModel) {
            [self reloadUI:YES];
        }
    }];
    [GKNovelNet bookDetail:self.bookId success:^(id  _Nonnull object) {
        self.model = [GKBookDetailModel modelWithJSON:object];
    } failure:^(NSString * _Nonnull error) {

    }];
}
#pragma mark dataSource
- (void)addAction:(UIButton *)sender{
    if (sender.selected) {
        [ATAlertView showTitle:@"确定从书架中移除该小说吗？" message:@"" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
            if (index > 0) {
                [GKBookCaseDataQueue deleteDataToDataBase:self.bookId completion:^(BOOL success) {
                    if (success) {
                        [self reloadUI:NO];
                    }
                }];
            }
        }];
    }else{
        if (self.model != nil) {
            [GKBookCaseDataQueue insertDataToDataBase:self.model completion:^(BOOL success) {
                if (success) {
                    [self reloadUI:YES];
                    [MBProgressHUD showMessage:@"已成功放入书架" toView:self.view];
                }
            }];
        }
    }
}
- (void)readAction{
    [GKJumpApp jumpToBookRead:self.model];
}
- (void)shareAction{
    [self presentPanModal:[GKShareViewController vcWithBookModel:self.model]];
}
#pragma mark get
- (GKBookDetailTabbar *)tabbar{
    if (!_tabbar) {
        _tabbar = [GKBookDetailTabbar instanceView];
        [_tabbar.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbar.readBtn addTarget:self action:@selector(readAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tabbar;
}
- (GKBookDetailCell *)topView{
    if (!_topView) {
        _topView = [GKBookDetailCell instanceView];
        [_topView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170 + NAVI_BAR_HIGHT)];
    }
    return _topView;
}
- (GKDetailNaviView *)naviView{
    if (!_naviView) {
        _naviView = [GKDetailNaviView instanceView];
        [_naviView.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.naviView.titleLab.isHidden ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
- (__kindof UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    BaseTableViewController *controller = pageViewController.controllersM[index];
    if ([controller isKindOfClass:BaseTableViewController.class]) {
        return  controller.tableView;
    }else if ([controller isKindOfClass:BaseConnectionController.class]){
        BaseConnectionController *vc = (BaseConnectionController *)controller;
        return vc.collectionView;
    }
    return  controller.tableView;
}
- (void)pageViewController:(YNPageViewController *)pageViewController contentOffsetY:(CGFloat)contentOffsetY progress:(CGFloat)progress{
    [self.naviView setAlphas:progress];
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
