//
//  GKSetViewManager.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSetViewManager.h"

#define gkSetHeight (220)
#define gkMoreSetHeight (220 + TAB_BAR_ADDING)
#define topHeight  NAVI_BAR_HIGHT
#define botHeight  TAB_BAR_ADDING + 49+40
#define time  0.4f
@implementation GKSetViewManager
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.botView];
        [self.botView addSubview:self.setView];
        [self.botView addSubview:self.bottomView];
        [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.botView.superview);
            make.height.offset(botHeight + gkSetHeight);
            make.bottom.equalTo(self.botView.superview).offset(botHeight+gkSetHeight);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.bottomView.superview);
            make.height.offset(botHeight);
        }];
        [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.setView.superview);
            make.height.offset(gkSetHeight);
            make.bottom.equalTo(self.bottomView.mas_top).offset(gkSetHeight);
        }];
        
        
        [self addSubview:self.topView];
        [self addSubview:self.tapView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.topView.superview);
            make.bottom.equalTo(self.topView.superview.mas_top).offset(0);
            make.height.offset(topHeight);
        }];
        self.setView.hidden = YES;
        [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tapView.superview);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.tapView addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        self.hidden = YES;
        
        [self addSubview:self.moreSetView];
        [self.moreSetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.moreSetView.superview);
            make.height.offset(gkMoreSetHeight);
            make.bottom.equalTo(self.moreSetView.superview).offset(gkMoreSetHeight);
        }];
        
        [self addSubview:self.directoryView];
        [self.directoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.directoryView.superview);
            make.right.equalTo(self.directoryView.superview.mas_left).offset(0);
            make.width.offset(SCREEN_WIDTH/3*2.0);
        }];
        
    }return self;
}
- (void)setBookModel:(GKBookModel *)bookModel{
    _bookModel = bookModel;
    self.topView.titleLab.text = bookModel.title ?:@"";
}
- (void)setChapterInfo:(GKBookChapterInfo *)bookChapter{
    _chapterInfo = bookChapter;
    NSArray *datas = bookChapter.chapters;
    self.directoryView.listData = datas;
    
}
- (void)setChapterModel:(GKBookChapterModel *)chapterModel{
    _chapterModel = chapterModel;
    self.directoryView.model = chapterModel;
}
- (void)setBookContent:(GKBookContentModel *)bookContent{
    _bookContent = bookContent;
    self.bottomView.slider.minimumValue = 0;
    self.bottomView.slider.maximumValue = bookContent.pageCount - 1;
    self.bottomView.slider.value = bookContent.pageIndex;
    self.topView.moreBtn.hidden = !bookContent.content.length;
}
- (void)tapAction{
    NSLog(@"========");
    if (!self.directoryView.hidden) {
        [self directoryHidden];
    }
    else if (!self.moreSetView.hidden) {
        [self moreSetHidden];
    }else{
        self.topView.hidden ? [self tapViewShow] : [self tapViewHidden:YES];
    }
}
- (void)tapViewShow{
    self.hidden = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = self.topView.hidden;
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView.superview);
        make.height.offset(topHeight);
        make.top.equalTo(self.topView.superview).offset(0);
    }];
    [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.botView.superview);
        make.height.offset(botHeight + gkSetHeight);
        make.bottom.equalTo(self.botView.superview).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        UIViewController *vc = [UIViewController rootTopPresentedController];
        if (finished) {
            [vc setNeedsStatusBarAppearanceUpdate];
        }
    }];
}
- (void)tapViewHidden:(BOOL)hidden{
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView.superview);
        make.bottom.equalTo(self.topView.superview.mas_top);
        make.height.offset(topHeight);
    }];
    [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.botView.superview);
        make.height.offset(botHeight+gkSetHeight);
        make.bottom.equalTo(self.botView.superview).offset(botHeight+gkSetHeight);
    }];
    [UIView animateWithDuration:time animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            
            self.topView.hidden = YES;
            self.bottomView.hidden = self.topView.hidden;
            self.hidden = hidden;
            UIViewController *vc = [UIViewController rootTopPresentedController];
            [vc setNeedsStatusBarAppearanceUpdate];
            [self setViewHidden];
        }
    }];
}
- (void)setAction{
    self.setView.hidden ? [self setViewShow] : [self setViewHidden];
}
- (void)setViewShow{
    [self.setView loadData];
    self.setView.hidden = NO;
    [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.setView.superview);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
        make.height.offset(gkSetHeight);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.botView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tapView.superview);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.setView.mas_top);
        }];
    }];
}
- (void)setViewHidden{
    [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.setView.superview);
        make.height.offset(gkSetHeight);
        make.bottom.equalTo(self.bottomView.mas_top).offset(gkSetHeight);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.botView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.setView.hidden = YES;
        [self.tapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tapView.superview);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    }];
}
- (void)moreSetAction{
    if (self.moreSetView.hidden) {
        [self tapViewHidden:NO];
        [self moreSetShow];
    }else{
        [self moreSetHidden];
    }
}
- (void)moreSetShow{

    self.moreSetView.hidden = NO;
    [self.moreSetView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.moreSetView.superview);
        make.height.offset(gkMoreSetHeight);
        make.bottom.equalTo(self.moreSetView.superview).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}
- (void)moreSetHidden{
    [self.moreSetView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.moreSetView.superview);
        make.height.offset(gkMoreSetHeight);
        make.bottom.equalTo(self.moreSetView.superview).offset(gkMoreSetHeight);
    }];
    [UIView animateWithDuration:time animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
         self.moreSetView.hidden = YES;
        self.hidden = YES;
        UIViewController *vc = [UIViewController rootTopPresentedController];
        [vc setNeedsStatusBarAppearanceUpdate];
    }];
}
- (void)directoryAction{
    if (self.directoryView.hidden) {
        [self tapViewHidden:NO];
        [self directoryShow];
    }else{
        [self directoryHidden];
    }
}
- (void)directoryShow{
    self.tapView.backgroundColor = [UIColor clearColor];
    [self.directoryView show];
    self.directoryView.hidden = NO;
    [self.directoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.directoryView.superview);
        make.width.offset(SCREEN_WIDTH - SCALEW(50));
        make.left.equalTo(self.directoryView.superview).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        self.tapView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
       
    }];
}
- (void)directoryHidden{
    self.tapView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
    [self.directoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.directoryView.superview);
        make.width.offset(SCREEN_WIDTH - SCALEW(50));
        make.right.equalTo(self.directoryView.superview.mas_left).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        self.tapView.backgroundColor = [UIColor clearColor];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.directoryView.hidden = YES;
        self.hidden = YES;
        UIViewController *vc = [UIViewController rootTopPresentedController];
        [vc setNeedsStatusBarAppearanceUpdate];
    }];
}
#pragma mark get
- (GKReadTopView *)topView{
    if (!_topView) {
        _topView = [GKReadTopView instanceView];
        _topView.hidden = YES;
    }
    return _topView;
}
- (GKReadBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [GKReadBottomView instanceView];
        [_bottomView.setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.cataBtn addTarget:self action:@selector(directoryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (GKReadSetView *)setView{
    if (!_setView) {
        _setView = [GKReadSetView instanceView];
    }
    return _setView;
}
- (GKMoreSetView *)moreSetView{
    if (!_moreSetView) {
        _moreSetView = [GKMoreSetView instanceView];
        _moreSetView.hidden = YES;
    }
    return _moreSetView;
}
- (GKDirectoryView *)directoryView{
    if (!_directoryView) {
        _directoryView = [[GKDirectoryView alloc] init];
        _directoryView.hidden = YES;
    }
    return _directoryView;
}
- (UIButton *)tapView{
    if (!_tapView) {
        _tapView = [[UIButton alloc] init];
        _tapView.userInteractionEnabled = YES;
    }
    return _tapView;
}
- (UIView *)botView{
    if (!_botView) {
        _botView = [[UIView alloc] init];
    }
    return _botView;
}

@end
