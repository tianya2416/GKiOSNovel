//
//  GKReadContentController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadContentController.h"
#import "UIViewController+Tool.h"
#import "GKReadViewController.h"
#import "GKBookChapterController.h"
#import "GKBookSourceModel.h"
#import "GKBookChapterModel.h"
#import "GKBookContentModel.h"
#import "GKBookReadModel.h"
#import "GKReadView.h"
#import "GKBookCacheTool.h"
#import "AppDelegate.h"
#import "DZMCoverController.h"
#import "GKSetViewManager.h"
#import "BaseNetCache.h"
#import "GKNovelDown.h"
@interface GKReadContentController ()<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
DZMCoverControllerDelegate,
UIGestureRecognizerDelegate,
GKReadSetDelegate,
GKReadBottomDelegate,
GKReadTopDelegate,
GKDirectoryDelegate,
GKReadViewDelegate>
@property (strong, nonatomic) UIPageViewController *pageCtrl;
@property (strong, nonatomic) DZMCoverController *pageCoverCtrl;
@property (strong, nonatomic) GKSetViewManager *managerSetView;


@property (strong, nonatomic) GKBookDetailModel *bookModel;
@property (strong, nonatomic) GKBookSourceInfo *sourceInfo;
@property (strong, nonatomic) GKBookChapterInfo *chapterInfo;

@property (strong, nonatomic) GKBookContentModel *bookContent;

@property (strong, nonatomic) GKBookReadModel *readModel;

@property (assign, nonatomic) NSInteger chapter;
@property (assign, nonatomic) NSInteger pageIndex;

@property (assign, nonatomic) BOOL landscape;
@property (assign, nonatomic) BOOL pagecurl;
@end

@implementation GKReadContentController
+ (instancetype)vcWithBookDetailModel:(GKBookDetailModel *)model{
    GKReadContentController *vc = [[[self class] alloc] init];
    vc.bookModel = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)loadData{
    self.chapter = 0;
    self.pageIndex = 0;
   // [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [GKBookReadDataQueue getDataFromDataBase:self.bookModel.bookId completion:^(GKBookReadModel * _Nonnull readModel) {
        if (readModel.chapter > 0 ||readModel.pageIndex > 0) {
            self.readModel = readModel;
            self.chapter = readModel.chapter;
            self.pageIndex = readModel.pageIndex;
            self.sourceInfo = readModel.sourceInfo;
            self.chapterInfo = readModel.chapterInfo;
            [self loadBookContent:self.chapter];
        }else{
            [self loadBookSummary];
        }
    }];
}
//获取源
- (void)loadBookSummary{
    [GKNovelNetManager bookSummary:self.bookModel.bookId success:^(id  _Nonnull object) {
        self.sourceInfo.listData = [NSArray modelArrayWithClass:GKBookSourceModel.class json:object];
        [self loadBookChapters:0];
    } failure:^(NSString * _Nonnull error) {
       // [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showMessage:error];
    }];
}
//获取章节列表
- (void)loadBookChapters:(NSInteger)sourceIndex{
    self.sourceInfo.sourceIndex = sourceIndex;
    [GKNovelNetManager bookChapters:self.sourceInfo.bookSourceId success:^(id  _Nonnull object) {
        self.chapterInfo = [GKBookChapterInfo modelWithJSON:object];
        [self loadBookContent:0];
    } failure:^(NSString * _Nonnull error) {
       // [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showMessage:error];
    }];
}
//获取章节内容
- (void)loadBookContent:(NSInteger)chapter{
    GKBookChapterModel *model = [self.chapterInfo.chapters objectSafeAtIndex:chapter];
    [GKBookCacheTool bookContent:model.link contentId:model.chapterId bookId:self.bookModel.bookId sameSource:self.sourceInfo.sourceIndex success:^(GKBookContentModel * _Nonnull model) {
        self.bookContent = model;
        [self.bookContent setContentPage];
        [self reloadData];
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:error];
    }];
}
- (void)loadUI{
    self.fd_prefersNavigationBarHidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate =self;
    [self.view addSubview:self.managerSetView];
    [self.managerSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.managerSetView.superview);
    }];
    self.pagecurl ? [self loadPageUI] : [self loadCoverUI];
}
- (void)removePageCtrl{
    if (_pageCtrl) {
        [_pageCtrl.view removeFromSuperview];
        [_pageCtrl removeFromParentViewController];
        _pageCtrl.dataSource = nil;
        _pageCtrl.delegate = nil;
        _pageCtrl = nil;
    }
}
- (void)loadPageUI{
    [self removeCoverCtrl];
    [self removePageCtrl];
    GKSet *model = [GKSetManager shareInstance].model;
    UIPageViewControllerTransitionStyle style = 0;
    UIPageViewControllerNavigationOrientation orien = 0;
    switch (model.browseState) {
        case GKBrowseDefault:
            style = UIPageViewControllerTransitionStyleScroll;
            orien = UIPageViewControllerNavigationOrientationHorizontal;
            break;
        case GKBrowsePageCurl:
            style = UIPageViewControllerTransitionStylePageCurl;
            orien = UIPageViewControllerNavigationOrientationHorizontal;
            break;
        default:
            style = UIPageViewControllerTransitionStyleScroll;
            orien = UIPageViewControllerNavigationOrientationVertical;
            break;
    }
    self.pageCtrl = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:orien options:nil];
    UIViewController *vc = [[GKReadViewController alloc] init];
    [self.pageCtrl setViewControllers:@[vc]
                            direction:UIPageViewControllerNavigationDirectionForward
                             animated:NO
                           completion:nil];
    self.pageCtrl.dataSource = self;
    self.pageCtrl.delegate = self;
    [self addChildViewController:self.pageCtrl];
    [self.view addSubview:self.pageCtrl.view];
    [self.view sendSubviewToBack:self.pageCtrl.view];
    [self.pageCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageCtrl.view.superview);
    }];
    [self.pageCtrl didMoveToParentViewController:self];
    
}
- (void)removeCoverCtrl{
    if (_pageCoverCtrl) {
        [_pageCoverCtrl.view removeFromSuperview];
        [_pageCoverCtrl removeFromParentViewController];
        _pageCoverCtrl.delegate = nil;
        _pageCoverCtrl = nil;
    }
}
- (void)loadCoverUI{
    [self removeCoverCtrl];
    [self removePageCtrl];
    GKSet *model = [GKSetManager shareInstance].model;
    self.pageCoverCtrl = [[DZMCoverController alloc] init];
    UIViewController *vc = [[GKReadViewController alloc] init];
    [self.pageCoverCtrl setController:vc];
    self.pageCoverCtrl.delegate = self;
    [self addChildViewController:self.pageCoverCtrl];
    [self.view addSubview:self.pageCoverCtrl.view];
    [self.view sendSubviewToBack:self.pageCoverCtrl.view];
    [self.pageCoverCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageCoverCtrl.view.superview);
    }];
    [self.pageCoverCtrl didMoveToParentViewController:self];
    self.pageCoverCtrl.openAnimate = model.browseState == GKBrowseDefault ? YES : NO;
}
- (void)reloadUI{
    self.pagecurl ? [self reloadPageUI] : [self reloadCover];
}
- (void)reloadPageUI{
    UIViewController *vc = [self getReadCotroller];
    [self.pageCtrl setViewControllers:@[vc]
                            direction:UIPageViewControllerNavigationDirectionForward
                             animated:NO
                           completion:nil];
}
- (void)reloadCover{
    UIViewController *vc = [self getReadCotroller];
    [self.pageCoverCtrl setController:vc];
}
- (void)resetDataView:(BOOL)fullscreen{
    NSArray *datas = [self.bookContent positionDatas];
    NSNumber *position= [datas objectSafeAtIndex:self.pageIndex];;
    [self.bookContent setContentPage];
    self.pageIndex = [self.bookContent getChangeIndex:position];
    [self reloadUI];
}
#pragma mark buttonAction
- (void)tapAction:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    if (point.x < SCREEN_WIDTH/3.0f) {
        [self leftAction];
    }else if (point.x > SCREEN_HEIGHT/3.0f){
        [self rightAction];
    }else if (point.y > 0 && point.y < SCREEN_HEIGHT/4*3.0f){
        [self centerAction];
    }else{
        [self rightAction];
    }
}
- (void)centerAction{
    [self.managerSetView tapAction];
}
- (void)leftAction{
    UIViewController *vc = [self beforeController];
    [self.pageCtrl setViewControllers:@[vc]
                            direction:UIPageViewControllerNavigationDirectionForward
                             animated:NO
                           completion:nil];
}
- (void)rightAction{
    UIViewController *vc = [self afterController];
    [self.pageCtrl setViewControllers:@[vc]
                            direction:UIPageViewControllerNavigationDirectionForward
                             animated:NO
                           completion:nil];
}

- (void)reloadData{
    if ([GKSetManager shareInstance].model.landscape) {
        [self readSetView:nil screen:[GKSetManager shareInstance].model.landscape];
    }else{
        [self reloadUI];
    }
    if (self.chapter + 1 >= self.chapterInfo.chapters.count) {
        self.chapter = self.chapterInfo.chapters.count - 1;
    }
    self.managerSetView.bookContent = self.bookContent;
    self.managerSetView.chapterInfo = self.chapterInfo;
    self.managerSetView.chapterModel =  [self.chapterInfo.chapters objectSafeAtIndex:self.chapter];
    self.managerSetView.bookModel = self.bookModel;
}
- (void)insertDataQueue{
    self.bookContent.pageIndex = self.pageIndex;
    self.managerSetView.bookContent = self.bookContent;
    GKBookSourceInfo *souceInfo = self.sourceInfo.bookSourceId ?self.sourceInfo: self.readModel.sourceInfo;
    GKBookChapterInfo *chapterInfo = self.chapterInfo.chapters.count > 0 ? self.chapterInfo : self.readModel.chapterInfo;
    GKBookReadModel *read = [[GKBookReadModel alloc] init];
    read.bookId = self.bookModel.bookId;
    read.bookModel = self.bookModel;
    read.sourceInfo = souceInfo;
    read.chapterInfo = chapterInfo;
    read.pageIndex = self.pageIndex;
    read.chapter = self.chapter;
    read.updateTime = @"";
    [GKBookReadDataQueue insertDataToDataBase:read completion:^(BOOL success) {
        if (success) {
            NSLog(@"insert successful");
        }
    }];
}
#pragma mark buttonAction
- (void)goBack{
    [super goBack:NO];
    [self insertDataQueue];
    [BaseNetCache removeMemory];
}
#pragma mark UIPageViewControllerDelegate,UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(GKReadViewController *)viewController {
    return [self beforeController];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(GKReadViewController *)viewController {
    return [self afterController];
}
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = pageViewController.viewControllers.firstObject;
    if (currentViewController) {
        NSArray *viewControllers = @[currentViewController];
        [self.pageCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.pageCtrl.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }
    return UIPageViewControllerSpineLocationNone;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    [self currentController:(GKReadViewController *)self.pageCtrl.viewControllers.firstObject];
    NSLog(@"didFinishAnimating");
}
#pragma mark DZMCoverControllerDelegate
- (void)coverController:(DZMCoverController * _Nonnull)coverController currentController:(GKReadViewController * _Nullable)currentController finish:(BOOL)isFinish{
    [self currentController:currentController];
}
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getAboveControllerWithCurrentController:(UIViewController * _Nullable)currentController{
    return [self beforeController];
}
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getBelowControllerWithCurrentController:(UIViewController * _Nullable)currentController{
    return [self afterController];
}
- (void)currentController:(GKReadViewController *)currentController{
    if (self.pageIndex != currentController.pageIndex) {
        self.pageIndex = currentController.pageIndex;
    }
    if (self.chapter != currentController.chapter) {
        self.chapter = currentController.chapter;
        [self getBookContent:self.chapter];
    }
}
- (GKReadViewController *)beforeController{
    if (self.pageIndex <= 0 &&self.chapter <= 0) {
        [MBProgressHUD showMessage:@"当前第一章，第一页"];
        return nil;
    }else if (self.pageIndex <= 0){
        GKReadViewController *vc = self.pagecurl ? self.pageCtrl.viewControllers.firstObject : (GKReadViewController *)self.pageCoverCtrl.currentController;
        if (vc.chapter == self.chapter) {
            self.chapter -- ;
            [self getBookContent:self.chapter];
            self.pageIndex = self.bookContent.pageCount-1;
        }
    }else{
        GKReadViewController *vc = self.pagecurl ? self.pageCtrl.viewControllers.firstObject : (GKReadViewController *)self.pageCoverCtrl.currentController;
        if (vc.pageIndex == self.pageIndex) {
            self.pageIndex -- ;
        }
    }
    return [self getReadCotroller];
}
- (GKReadViewController *)afterController{
    
    NSArray *chapters = self.chapterInfo.chapters;
    if (self.pageIndex >= self.bookContent.pageCount-1 && self.chapter >= chapters.count){
        [MBProgressHUD showMessage:@"当前最后一章，最后一页"];
        return nil;
    }else if (self.pageIndex >= self.bookContent.pageCount-1){
        GKReadViewController *vc = self.pagecurl ? self.pageCtrl.viewControllers.firstObject : (GKReadViewController *)self.pageCoverCtrl.currentController;
        if (vc.chapter == self.chapter) {
            self.chapter ++ ;
            [self getBookContent:self.chapter];
            self.pageIndex = 0;
        }
    }else{
        GKReadViewController *vc = self.pagecurl ? self.pageCtrl.viewControllers.firstObject : (GKReadViewController *)self.pageCoverCtrl.currentController;
        if (vc.pageIndex == self.pageIndex) {
            self.pageIndex ++ ;
        }
    }
    return [self getReadCotroller];
}
- (GKReadViewController *)getReadCotroller{
    GKReadViewController *vc = [[GKReadViewController alloc] init];
    vc.delegate = self;
    [self getBeforeData];
    [self getAfterData];
    [vc setModel:self.bookContent chapter:self.chapter pageIndex:self.pageIndex];
    return vc;
}
- (void)getBookContent:(NSInteger)chapter{
    NSArray *chapters = self.chapterInfo.chapters;
    GKBookChapterModel *info = [chapters objectSafeAtIndex:chapter];
    self.bookContent = info.bookContent;
    if (!info) {
        GKBookContentModel *lastContent = [[GKBookContentModel alloc] init];
        lastContent.content = @"已无最新内容啦！请您关注我官网更新...";
        self.bookContent = lastContent;
    }
    [self.bookContent setContentPage];
}
- (void)getBeforeData{
    NSArray *chapterDatas = self.chapterInfo.chapters;
    NSInteger chapter = self.chapter - 1;
    if (chapterDatas.count > chapter && chapter>= 0) {
        GKBookChapterModel *model = chapterDatas[chapter];
        [GKBookCacheTool bookContent:model.link contentId:model.chapterId bookId:self.bookModel.bookId sameSource:self.sourceInfo.sourceIndex success:^(GKBookContentModel *bookContent) {
            [BaseNetCache setMemoryObject:bookContent forkey:model.chapterId];
        } failure:nil];
    }
}
- (void)getAfterData{
    NSArray *chapterDatas = self.chapterInfo.chapters;
    NSInteger chapter = self.chapter + 1;
    if (self.bookContent.pageCount > self.pageIndex && chapterDatas.count > chapter) {
        GKBookChapterModel *model = chapterDatas[chapter];
        [GKBookCacheTool bookContent:model.link contentId:model.chapterId bookId:self.bookModel.bookId sameSource:self.sourceInfo.sourceIndex success:^(GKBookContentModel *bookContent) {
            [BaseNetCache setMemoryObject:bookContent forkey:model.chapterId];
        } failure:nil];
    }
}
#pragma mark GKDirectoryDelegate
- (void)directoryView:(GKDirectoryView *__nullable)setView chapter:(NSInteger)chapter{
    self.chapter = chapter;
    self.pageIndex = 0;
    [self loadBookContent:self.chapter];
    [self.managerSetView tapAction];
}
#pragma mark GKReadTopDelegate
- (void)readTopView:(GKReadTopView *)setView goBack:(BOOL)goBack{
    [self goBack];
}
- (void)readTopView:(GKReadTopView *__nullable)setView down:(BOOL)down{
   [GKNovelDown addDownTask:self.bookModel chapters:self.chapterInfo.chapters];
}
#pragma mark GKReadSetDelegate
- (void)readSetView:(GKReadSetView *)setView font:(CGFloat)font{
    [self resetDataView:NO];
}
- (void)readSetView:(GKReadSetView *)setView state:(GKSkinState)state{
    [self resetDataView:NO];
}
- (void)readSetView:(GKReadSetView *)setView screen:(BOOL)screen{
    UIInterfaceOrientation orientation = screen? UIInterfaceOrientationLandscapeRight: UIInterfaceOrientationPortrait;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.makeOrientation = orientation;
    [self setOrientations:orientation];
    self.fd_interactivePopDisabled = self.landscape;
    [self resetDataView:YES];
}
- (void)setOrientations:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}
- (void)readSetView:(GKReadSetView *__nullable)moreView browState:(GKBrowseState)browState{
    [self insertDataQueue];
    self.pagecurl ? [self loadPageUI] : [self loadCoverUI];
    [self reloadData];
}
#pragma mark GKReadBottomDelegate
- (void)bottomView:(GKReadBottomView *__nullable)bottomView day:(BOOL)day{
    [GKSetManager setNight:!day];
    [self resetDataView:NO];
}
- (void)bottomView:(GKReadBottomView *__nullable)bottomView last:(BOOL)last{
    NSArray *listData = self.chapterInfo.chapters;
    if (self.chapter == 0 && last) {
        [MBProgressHUD showMessage:@"已经是第一章"];
        return;
    }
    if (self.chapter + 1 == listData.count && !last){
        [MBProgressHUD showMessage:@"已经是最后一章"];
        return;
    }
    last ? self.chapter -- : self.chapter ++;
    self.pageIndex = 0;
    [self loadBookContent:self.chapter];
}
- (void)bottomView:(GKReadBottomView *__nullable)bottomView page:(NSInteger)page{
    self.pageIndex = page;
    [self reloadUI];
    
}
#pragma mark GKReadViewDelegate
- (void)viewDidAppear:(GKReadViewController *)ctrl animated:(BOOL)animated{
    
}
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return [touch.view isKindOfClass:GKReadView.class];
}
#pragma mark get
- (GKSetViewManager *)managerSetView{
    if (!_managerSetView) {
        _managerSetView = [[GKSetViewManager alloc] init];
        _managerSetView.setView.delegate = self;
        _managerSetView.bottomView.delegate =self;
        _managerSetView.topView.delegate = self;
        _managerSetView.directoryView.delegate = self;
    }
    return _managerSetView;
}
- (GKBookSourceInfo *)sourceInfo{
    if (!_sourceInfo) {
        _sourceInfo = [[GKBookSourceInfo alloc] init];
    }
    return _sourceInfo;
}

- (BOOL)landscape{
    UIInterfaceOrientation state= [UIApplication sharedApplication].statusBarOrientation;
    return state == UIInterfaceOrientationLandscapeLeft || state == UIInterfaceOrientationLandscapeRight;
}
- (BOOL)prefersStatusBarHidden{
    return !self.landscape ? self.managerSetView.hidden : YES;
}
- (BOOL)pagecurl{
    GKSet *model = [GKSetManager shareInstance].model;
    return model.browseState == GKBrowsePageCurl;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#pragma mark base
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
