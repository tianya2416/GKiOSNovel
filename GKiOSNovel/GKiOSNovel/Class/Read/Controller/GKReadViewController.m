//
//  GKReadViewController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadViewController.h"
#import "GKReadView.h"
@interface GKReadViewController ()
@property (strong, nonatomic) UIImageView *mainView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *bookNameLab;
@property (strong, nonatomic) UILabel *selectLab;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger chapterIndex;
@property (strong, nonatomic)GKReadView *readView;
@end

@implementation GKReadViewController
- (void)dealloc{

}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if ([self landscape]) {
        [self landscapeFrame];
    }else{
        [self portraitFrame];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self loadUI];
    [self loadData];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.delegate respondsToSelector:@selector(viewDidAppear:animated:)]) {
        [self.delegate viewDidAppear:self animated:animated];
    }
}
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title bookName:(NSString *)bookName content:(NSAttributedString *)content{
    self.pageIndex = currentPage;
    self.chapterIndex = chapter;
    self.readView.content = content;
    self.titleLab.text = title ;
    self.bookNameLab.text = bookName ?:@"";
    currentPage = currentPage + 1 >totalPage ? totalPage : currentPage + 1;
    self.selectLab.text = [NSString stringWithFormat:@"%@/%@",@(currentPage),@(totalPage)];
    self.selectLab.textColor = [UIColor colorWithHexString:[GKReadSetManager shareInstance].model.color];
    self.titleLab.textColor = [UIColor colorWithHexString:[GKReadSetManager shareInstance].model.color];
}

- (void)loadUI{

    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView.superview);
    }];
    [self.view addSubview:self.readView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.bookNameLab];

    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.view addSubview:self.selectLab];
    [self portraitFrame];
}
- (void)landscapeFrame{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        insets = self.view.safeAreaInsets;
    }
    [self.readView setFrame:[BaseMacro appFrame]];
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.superview).offset(insets.left+AppTop);
        make.top.equalTo(self.titleLab.superview).offset(10+insets.top);
    }];
    [self.bookNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bookNameLab.superview).offset(-AppTop - insets.right);
        make.centerY.equalTo(self.titleLab);
        make.left.equalTo(self.titleLab.mas_right).offset(10);
    }];
    [self.selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bookNameLab);
        make.bottom.equalTo(self.selectLab.superview).offset(-10);
    }];
}
- (void)portraitFrame{
    [self.readView setFrame:[BaseMacro appFrame]];
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.superview).offset(AppTop);
        make.top.equalTo(self.titleLab.superview).offset(STATUS_BAR_HIGHT);
    }];
    [self.bookNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bookNameLab.superview).offset(-AppTop);
        make.centerY.equalTo(self.titleLab);
        make.left.equalTo(self.titleLab.mas_right).offset(10);
    }];
    [self.selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLab.superview).offset(-15);
        make.bottom.equalTo(self.selectLab.superview).offset(-TAB_BAR_ADDING-10);
    }];
}
- (void)loadData{
    self.mainView.image = [GKReadSetManager defaultSkin];
}
- (GKReadView *)readView{
    if (!_readView) {
        _readView = [[GKReadView alloc] initWithFrame:AppReadContent];
        _readView.backgroundColor = [UIColor clearColor];
    }
    return _readView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = Appx999999;
        _titleLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _titleLab;
}
- (UILabel *)bookNameLab{
    if (!_bookNameLab) {
        _bookNameLab = [[UILabel alloc] init];
        _bookNameLab.textAlignment = NSTextAlignmentRight;
        _bookNameLab.textColor = Appx999999;
        _bookNameLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _bookNameLab;
}
- (UILabel *)selectLab{
    if (!_selectLab) {
        _selectLab = [[UILabel alloc] init];
        _selectLab.textAlignment = NSTextAlignmentCenter;
        _selectLab.textColor = Appx999999;
        _selectLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _selectLab;
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
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
}
@end
