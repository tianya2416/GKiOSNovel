//
//  GKReadContentController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadContentController.h"
#import "GKReadViewController.h"
#import "GKBookSourceModel.h"
#import "GKBookChapterModel.h"
#import "GKBookContentModel.h"
#import "GKReadTopView.h"
#import "GKReadBottomView.h"
#import "GKReadView.h"
@interface GKReadContentController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) GKReadTopView *topView;
@property (strong, nonatomic) GKReadBottomView *bottomView;

@property (strong, nonatomic) GKBookDetailModel *model;
@property (strong, nonatomic) GKBookSourceInfo *bookSource;
@property (strong, nonatomic) GKBookChapterInfo *bookChapter;
@property (strong, nonatomic) GKBookContentModel *bookContent;

@property (assign, nonatomic) NSInteger chapter;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL forward;
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
    self.chapter = 0;
    self.pageIndex = 0;
    
    self.topView.titleLab.text = self.model.title?:@"";
    self.fd_prefersNavigationBarHidden = YES;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.doubleSided = NO;
    
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageViewController.view.superview);
    }];
    
    [self.pageViewController didMoveToParentViewController:self];

    [self performSelector:@selector(tapAction) withObject:nil afterDelay:3];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.topView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bottomView.superview);
        make.height.offset(TAB_BAR_ADDING + 49);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.center.equalTo(btn.superview);
    }];
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
}
- (UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex chapter:(NSInteger)chapterIndex
{
    GKReadViewController *vc = [[GKReadViewController alloc] init];
    if (chapterIndex != self.chapter) {
        self.chapter = chapterIndex;
        [self loadBookContent:chapterIndex];
    }
    [vc setCurrentPage:pageIndex totalPage:self.bookContent.pageCount chapter:self.chapter title:self.bookContent.title content:[self.bookContent getContentAtt:pageIndex]];
    return vc;
}
- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_semaphore_t sem1 = dispatch_semaphore_create(0);
    dispatch_semaphore_t sem2 = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [GKNovelNetManager bookSummary:self.model._id success:^(id  _Nonnull object) {
            self.bookSource.listData = [NSArray modelArrayWithClass:GKBookSourceModel.class json:object];
            dispatch_semaphore_signal(sem1);
        } failure:^(NSString * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sem1,DISPATCH_TIME_FOREVER);
        [GKNovelNetManager bookChapters:self.bookSource.bookSourceId success:^(id  _Nonnull object) {
            self.bookChapter = [GKBookChapterInfo modelWithJSON:object];
            dispatch_semaphore_signal(sem2);
        } failure:^(NSString * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sem2,DISPATCH_TIME_FOREVER);
        [self loadBookContent:0];
    });
}

- (void)loadBookContent:(NSInteger )chapterIndex{
    if (self.bookChapter.chapters.count > chapterIndex) {
        GKBookChapterModel *model = self.bookChapter.chapters[chapterIndex];
        [GKNovelNetManager bookContent:model.link success:^(id  _Nonnull object) {
            self.bookContent = [GKBookContentModel modelWithJSON:object[@"chapter"]];
            [self.bookContent setContentPage];
            [self reloadUI];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSString * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        [MBProgressHUD showMessage:@"没有下一章了"];
    }
}
- (void)reloadUI{
    UIViewController *vc = [self viewControllerAtPage:self.pageIndex chapter:self.chapter];
    [self.pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
}
#pragma mark UIPageViewControllerDelegate,UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(GKReadViewController *)viewController {
    NSLog(@"%s", __FUNCTION__);
    NSInteger pageIndex = viewController.pageIndex;
    NSUInteger chapter = viewController.chapterIndex;
    if (pageIndex == 0 && chapter == 0){
        return nil;
    }
    if (pageIndex > 0) {
        pageIndex = pageIndex - 1;
    }else{
        //chapter = chapter - 1;
        if (pageViewController.) {
            <#statements#>
        }
        pageIndex = self.bookContent.pageCount - 1;
    }
    return [self viewControllerAtPage:pageIndex chapter:chapter];
    
    
}
#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(GKReadViewController *)viewController {
    NSLog(@"%s", __FUNCTION__);
    NSUInteger pageIndex = viewController.pageIndex;
    NSUInteger chapter = viewController.chapterIndex;
    if (pageIndex >= self.bookContent.pageCount) {
        pageIndex = 0;
        chapter = chapter + 1;
    }else{
        pageIndex = pageIndex + 1;
    }
    return [self viewControllerAtPage:pageIndex chapter:chapter];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    pageViewController.view.userInteractionEnabled = NO;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed && finished) {
        pageViewController.view.userInteractionEnabled = YES;
    }
}

#pragma mark buttonAction
- (void)tapAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction) object:nil];
    self.topView.hidden ? [self tapViewShow] : [self tapViewHidden];
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
    [self goBack:NO];
}
- (void)moreAction{
    
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
    }
    return _bottomView;
}

#pragma mark get

- (GKBookSourceInfo *)bookSource{
    if (!_bookSource) {
        _bookSource = [[GKBookSourceInfo alloc] init];
    }
    return _bookSource;
}
- (BOOL)prefersStatusBarHidden{
    return self.topView.hidden;
}

@end
