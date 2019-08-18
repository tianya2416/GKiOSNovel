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
#import "GKReadTopView.h"
#import "GKReadBottomView.h"
#import "GKReadSetView.h"
#import "GKReadView.h"
#import "GKBookCacheTool.h"
#import "AppDelegate.h"
#import "GKMoreSetView.h"
#import "DZMCoverController.h"
#define gkSetHeight (180 + TAB_BAR_ADDING)

#define gkMoreSetHeight (200 + TAB_BAR_ADDING)

@interface GKReadContentController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,GKReadSetDelegate,GKMoreSetDelegate,DZMCoverControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) DZMCoverController *pageCoverCtrl;
@property (strong, nonatomic) UIImageView *mainView;
@property (strong, nonatomic) GKReadTopView *topView;
@property (strong, nonatomic) GKReadBottomView *bottomView;
@property (strong, nonatomic) GKReadSetView *setView;
@property (strong, nonatomic) GKMoreSetView *moreSetView;

@property (strong, nonatomic) GKBookDetailModel *model;
@property (strong, nonatomic) GKBookSourceInfo *bookSource;
@property (strong, nonatomic) GKBookChapterInfo *bookChapter;
@property (strong, nonatomic) GKBookContentModel *bookContent;

@property (strong, nonatomic) GKBookReadModel *bookModel;

@property (assign, nonatomic) NSInteger chapter;
@property (assign, nonatomic) NSInteger pageIndex;

@property (assign, nonatomic) BOOL landscape;
@property (assign, nonatomic) BOOL pagecurl;
@end

@implementation GKReadContentController
+ (instancetype)vcWithBookDetailModel:(GKBookDetailModel *)model{
    GKReadContentController *vc = [[[self class] alloc] init];
    vc.model = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView.superview);
    }];
    self.topView.titleLab.text = self.model.title?:@"";
    self.fd_prefersNavigationBarHidden = YES;

    [self performSelector:@selector(tapAction) withObject:nil afterDelay:0.50];
    [self.mainView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.topView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.mainView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bottomView.superview);
        make.height.offset(TAB_BAR_ADDING + 49);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCALEW(150));
        make.height.offset(SCALEW(150));
        make.center.equalTo(btn.superview);
    }];
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.setView.superview);
        make.height.offset(gkSetHeight);
        make.bottom.offset(gkSetHeight);
    }];
    self.setView.hidden = YES;
    
    [self.mainView addSubview:self.moreSetView];
    [self.moreSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.setView.superview);
        make.height.offset(gkSetHeight);
        make.bottom.offset(gkSetHeight);
    }];
    self.moreSetView.hidden = YES;
    if (self.pagecurl) {
        [self setUpPageView];
    }else{
        [self setPageCoverCtrl];
    }
}
- (void)removePageCtrl{
    if (_pageViewController) {
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _pageViewController.dataSource = nil;
        _pageViewController.delegate = nil;
        _pageViewController = nil;
    }
}
- (void)setUpPageView{
    [self removeCoverCtrl];
    [self removePageCtrl];
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
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
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:orien options:nil];
    UIViewController *vc = [[GKReadViewController alloc] init];
    [self.pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.mainView addSubview:self.pageViewController.view];
    [self.mainView sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageViewController.view.superview);
    }];
    [self.pageViewController didMoveToParentViewController:self];
}
- (void)removeCoverCtrl{
    if (_pageCoverCtrl) {
        [_pageCoverCtrl.view removeFromSuperview];
        [_pageCoverCtrl removeFromParentViewController];
        _pageCoverCtrl.delegate = nil;
        _pageCoverCtrl = nil;
    }
}
- (void)setPageCoverCtrl{
    [self removeCoverCtrl];
    [self removePageCtrl];
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    self.pageCoverCtrl = [[DZMCoverController alloc] init];
    UIViewController *vc = [[GKReadViewController alloc] init];
    [self.pageCoverCtrl setController:vc];
    self.pageCoverCtrl.delegate = self;
    [self addChildViewController:self.pageCoverCtrl];
    [self.mainView addSubview:self.pageCoverCtrl.view];
    [self.mainView sendSubviewToBack:self.pageCoverCtrl.view];
    [self.pageCoverCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageCoverCtrl.view.superview);
    }];
    [self.pageCoverCtrl didMoveToParentViewController:self];
    self.pageCoverCtrl.openAnimate = model.browseState == GKBrowseDefault ? YES : NO;
}
- (void)loadData{
    [self readSetView:nil state:0];
    [GKBookReadDataQueue getDataFromDataBase:self.model._id completion:^(GKBookReadModel * _Nonnull bookModel) {
        if (bookModel.pageIndex >= 0 && bookModel.chapter >= 0 ) {
            self.bookModel = bookModel;
            self.pageIndex = bookModel.pageIndex;
            self.chapter = bookModel.chapter;
            [self loadBookSummary];
//            [self loadBookContent:YES chapter:self.chapter];
        }else{
            self.chapter = 0;
            self.pageIndex = 0;
            [self loadBookSummary];
        }
    }];
}
- (UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex chapter:(NSInteger)chapterIndex
{
    GKReadViewController *vc = [[GKReadViewController alloc] init];
    self.pageIndex = pageIndex;
    if (self.chapter != chapterIndex) {
        self.chapter = chapterIndex;
        [self loadBookContent:NO chapter:self.chapter];
    }
    [vc setCurrentPage:pageIndex totalPage:self.bookContent.pageCount chapter:self.chapter title:self.bookContent.title bookName:self.model.title content:[self.bookContent getContentAtt:pageIndex]];
    //预加载数据
    if (self.bookContent.pageCount > pageIndex && pageIndex == 0 && self.bookChapter.chapters.count > chapterIndex + 1) {
         GKBookChapterModel *model = self.bookChapter.chapters[chapterIndex + 1];
        [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.model._id sameSource:self.bookSource.sourceIndex success:nil failure:nil];
    }
    return vc;
}
//获取源
- (void)loadBookSummary{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [GKNovelNetManager bookSummary:self.model._id success:^(id  _Nonnull object) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        self.bookSource.listData = [NSArray modelArrayWithClass:GKBookSourceModel.class json:object];
        [self loadBookChapters:0];
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];

}
//获取章节列表
- (void)loadBookChapters:(NSInteger)sourceIndex{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    self.bookSource.sourceIndex = sourceIndex;
    [GKNovelNetManager bookChapters:self.bookSource.bookSourceId success:^(id  _Nonnull object) {
        self.bookChapter = [GKBookChapterInfo modelWithJSON:object];
       [self loadBookContent:NO chapter:self.chapter];
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}
//获取章节内容
- (void)loadBookContent:(BOOL)history chapter:(NSInteger)chapterIndex{
    GKBookChapterModel *model = self.bookChapter.chapters[chapterIndex];
    [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.model._id sameSource:self.bookSource.sourceIndex success:^(GKBookContentModel * _Nonnull model) {
        self.bookContent = model;
        [self reloadUI:history];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)reloadUI:(BOOL)history
{
    [self.bookContent setContentPage];
    if ([GKReadSetManager shareInstance].model.landscape) {
        [self readSetView:nil screen:[GKReadSetManager shareInstance].model.landscape];
    }else{
        [self reloadPageView];
    }
}
- (void)resetDataView:(BOOL)fullscreen{
     GKReadViewController *vc = self.pageViewController.viewControllers.firstObject;
    NSArray *datas = [self.bookContent positionDatas];
    NSNumber *position= @(0);
    if (datas.count > vc.pageIndex) {
        position = [[self.bookContent positionDatas] objectAtIndex:vc.pageIndex];
    }
    [self.bookContent setContentPage];
    self.pageIndex = [self.bookContent getChangeIndex:position];
    self.pageIndex = self.pageIndex < self.bookContent.pageCount ? self.pageIndex : self.bookContent.pageCount - 1;
    [self reloadPageView];
}

- (void)reloadPageView{
    self.pagecurl ? [self reloadCurl] : [self reloadDefault];
}
- (void)reloadDefault{
    UIViewController *vc = [self getReadCotroller];
    [self.pageCoverCtrl setController:vc];
}
- (void)reloadCurl{
    UIViewController *vc = [self getReadCotroller];
    [self.pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}
- (void)insertDataQueue{
    GKBookReadModel *readModel = [GKBookReadModel vcWithContent:self.bookContent bookId:self.model._id chapter:self.chapter pageIndex:self.pageIndex];
    readModel.bookModel = self.model;
    [GKBookReadDataQueue insertDataToDataBase:readModel completion:^(BOOL success) {
        if (success) {
            NSLog(@"insert successful");
        }
    }];
}
#pragma mark buttonAction
- (void)tapAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction) object:nil];
    if (!self.moreSetView.hidden) {
        [self setMoreAction];
    }
    else if (!self.setView.hidden) {
        [self setAction];
    }else{
        self.topView.hidden ? [self tapViewShow] : [self tapViewHidden];
    }
}
- (void)tapViewShow{
    self.topView.hidden = NO;
    self.bottomView.hidden = self.topView.hidden;
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
        make.top.equalTo(self.topView.superview).offset(0);
    }];
    CGFloat height = TAB_BAR_ADDING + 49;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView.superview);
        make.height.offset(height);
        make.bottom.equalTo(self.bottomView.superview).offset(0);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}
- (void)tapViewHidden{
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
        make.top.equalTo(self.topView.superview).offset(-NAVI_BAR_HIGHT);
    }];
    CGFloat height = TAB_BAR_ADDING + 49;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView.superview);
        make.height.offset(height);
        make.bottom.equalTo(self.bottomView.superview).offset(height);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.topView.hidden = YES;
            self.bottomView.hidden = self.topView.hidden;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}
- (void)goBack{
//    if (self.landscape) {
//        self.setView.switchBtn.on = NO;
//        [self readSetView:self.setView screen:self.setView.switchBtn.on];
//    }else
    {
        [super goBack:NO];;
    }
}
- (void)moreAction{
    GKBookSourceController *vc = [GKBookSourceController vcWithChapter:self.model._id sourceId:self.bookSource.bookSourceId completion:^(NSInteger index) {
        [self loadBookChapters:index];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setAction{
    if (self.setView.hidden) {
        [self tapViewHidden];
        [self.setView loadData];
        self.setView.hidden = NO;
        [self.setView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.setView.superview);
            make.height.offset(gkSetHeight);
            make.bottom.offset(0);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [self.setView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.setView.superview);
            make.height.offset(gkSetHeight);
            make.bottom.offset(gkSetHeight);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.setView.hidden = YES;
        }];
    }
}
- (void)setMoreAction{
    if (self.moreSetView.hidden) {
        [self setAction];
        self.moreSetView.hidden = NO;
        [self.moreSetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.setView.superview);
            make.height.offset(gkMoreSetHeight);
            make.bottom.offset(0);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [self.moreSetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.moreSetView.superview);
            make.height.offset(gkMoreSetHeight);
            make.bottom.offset(gkMoreSetHeight);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.moreSetView.hidden = YES;
        }];
    }
}
- (void)dayACtion:(UIButton *)sender{
    sender.selected = !sender.selected;
    GKReadThemeState state  = (sender.selected == NO) ? GKReadDefault : GKReadBlack;
    [GKReadSetManager setReadState:state];
    [self resetDataView:NO];
}
- (void)cataACtion:(UIButton *)sender{
    GKBookChapterController *vc = [GKBookChapterController vcWithChapter:self.bookSource.bookSourceId chapter:self.chapter completion:^(NSInteger index) {
        self.chapter = index;
        [self loadBookContent:NO chapter:index];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UIPageViewControllerDelegate,UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(GKReadViewController *)viewController {
    return [self aboveController];
}
#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(GKReadViewController *)viewController {
    return [self belowController];
}
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = pageViewController.viewControllers.firstObject;
    if (currentViewController) {
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }
    return UIPageViewControllerSpineLocationNone;
}
#pragma mark GKReadSetDelegate
- (void)readSetView:(GKReadSetView *)setView font:(CGFloat)font{
    [self resetDataView:NO];
}
- (void)readSetView:(GKReadSetView *)setView state:(GKReadThemeState)state{
    self.bottomView.dayBtn.selected = [GKReadSetManager shareInstance].model.state == GKReadBlack;
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
- (void)readSetView:(GKReadSetView * _Nullable)setView brightness:(CGFloat)brightness {
    
}
- (void)readSetView:(GKReadSetView *__nullable)setView moreSet:(BOOL)moreSet{
    [self setMoreAction];
}
#pragma mark GKMoreSetDelegate
- (void)moreSetView:(GKMoreSetView *__nullable)moreView traditional:(BOOL)traditional{
    [self resetDataView:NO];
}
- (void)moreSetView:(GKMoreSetView *__nullable)moreView fontName:(NSString *)fontName{
    [self resetDataView:NO];
}
- (void)moreSetView:(GKMoreSetView *)moreView browState:(GKBrowseState)browState{
    self.pagecurl ?     [self setUpPageView] : [self setPageCoverCtrl];
    [self loadData];
}
#pragma mark get

- (GKReadTopView *)topView{
    if (!_topView) {
        _topView = [GKReadTopView instanceView];
        [_topView.closeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [_topView.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
- (GKReadBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [GKReadBottomView instanceView];
        [_bottomView.setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.dayBtn addTarget:self action:@selector(dayACtion:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.cataBtn addTarget:self action:@selector(cataACtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (GKReadSetView *)setView{
    if (!_setView) {
        _setView = [GKReadSetView instanceView];
        _setView.delegate = self;
    }
    return _setView;
}
- (GKMoreSetView *)moreSetView{
    if (!_moreSetView) {
        _moreSetView = [GKMoreSetView instanceView];
        _moreSetView.delegate = self;
        _moreSetView.hidden = YES;
    }
    return _moreSetView;
}
#pragma mark get

- (GKBookSourceInfo *)bookSource{
    if (!_bookSource) {
        _bookSource = [[GKBookSourceInfo alloc] init];
    }
    return _bookSource;
}
- (UIImageView *)mainView{
    if (!_mainView) {
        _mainView = [[UIImageView alloc] init];
        _mainView.userInteractionEnabled = YES;
        _mainView.clipsToBounds = YES;
        _mainView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _mainView;
}
- (BOOL)landscape{
    UIInterfaceOrientation state= [UIApplication sharedApplication].statusBarOrientation;
    return state == UIInterfaceOrientationLandscapeLeft || state == UIInterfaceOrientationLandscapeRight;
}
- (BOOL)prefersStatusBarHidden{
    return !self.landscape ? self.topView.hidden : YES;
}
- (BOOL)pagecurl{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    return model.browseState == GKBrowsePageCurl;
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
#pragma mark DZMCoverControllerDelegate
- (void)coverController:(DZMCoverController * _Nonnull)coverController currentController:(GKReadViewController * _Nullable)currentController finish:(BOOL)isFinish{
    NSLog(@"currentController");
}
- (void)coverController:(DZMCoverController * _Nonnull)coverController willTransitionToPendingController:(UIViewController * _Nullable)pendingController{
    NSLog(@"willTransitionToPendingController");
}
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getAboveControllerWithCurrentController:(UIViewController * _Nullable)currentController{
    return [self aboveController];
}
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getBelowControllerWithCurrentController:(UIViewController * _Nullable)currentController{
     return [self belowController];
}
- (GKReadViewController *)aboveController{
    GKReadViewController *vc = self.pageViewController.viewControllers.firstObject;
    if (self.pageIndex <= 0 &&self.chapter <= 0) {
        [MBProgressHUD showMessage:@"第一章，第一页"];
        return nil;
    }else if (self.pageIndex <= 0){
        self.chapter --;
        GKBookChapterModel *info = [self.bookChapter.chapters objectSafeAtIndex:self.chapter];
        self.bookContent = info.bookContent;
        self.pageIndex = self.bookContent.pageCount-1;
    }else{
        self.pageIndex -= 1;
    }
    NSLog(@"----------------%@-----%@",@(self.pageIndex),@(vc.pageIndex));
   return [self getReadCotroller];
}
- (GKReadViewController *)belowController{
    GKReadViewController *vc = self.pageViewController.viewControllers.firstObject;
    if (self.pageIndex >= self.bookContent.pageCount-1 && self.chapter >= self.bookChapter.chapters.count){
        [MBProgressHUD showMessage:@"最后一章，最后一页"];
        return nil;
    }else if (self.pageIndex >= self.bookContent.pageCount-1){
        
        self.pageIndex = 0;
        self.chapter ++;
        GKBookChapterModel *info = [self.bookChapter.chapters objectSafeAtIndex:self.chapter];
        self.bookContent = info.bookContent;
    }else{
        self.pageIndex += 1;
    }
     NSLog(@"++++++++++++++++++%@ +++ %@",@(self.pageIndex),@(vc.pageIndex));
    return [self getReadCotroller];
}

- (GKReadViewController *)getReadCotroller{
    GKReadViewController *vc = [[GKReadViewController alloc] init];
    [self getAboveData];
    [self getBelowData];
    [vc setCurrentPage:self.pageIndex totalPage:self.bookContent.pageCount chapter:self.chapter title:self.bookContent.title bookName:self.model.title content:[self.bookContent getContentAtt:self.pageIndex]];
    return vc;
}
- (void)getAboveData{
    NSArray *chapterDatas = self.bookChapter.chapters;
    NSInteger chapter = self.chapter + 1;
    if (self.bookContent.pageCount > self.pageIndex && chapterDatas.count > chapter) {
        GKBookChapterModel *model = chapterDatas[chapter];
        [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.model._id sameSource:self.bookSource.sourceIndex success:nil failure:nil];
    }
}
- (void)getBelowData{
    NSArray *chapterDatas = self.bookChapter.chapters;
    NSInteger chapter = self.chapter - 1;
    if (chapterDatas.count > chapter && chapter>=0) {
        GKBookChapterModel *model = chapterDatas[chapter];
        [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.model._id sameSource:self.bookSource.sourceIndex success:nil failure:nil];
    }
}
@end
