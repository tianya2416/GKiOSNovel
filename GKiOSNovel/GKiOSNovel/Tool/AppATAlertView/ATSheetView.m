//
//  ATSheetView.m
//  AT
//
//  Created by CoderLT on 15/11/17.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATSheetView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "MMSheetView.h"

@interface ATSheetView()
{
    BOOL _comfirm;
}
@end

@implementation ATSheetView
- (instancetype)init {
    if (self = [super init]) {
        self.type = MMPopupTypeSheet;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        _btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:[MMSheetViewConfig globalConfig].itemHighlightColor forState:UIControlStateNormal];
        
        _btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionConfirm)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:[MMSheetViewConfig globalConfig].itemHighlightColor forState:UIControlStateNormal];
        
        _contentView= [[UIView alloc] init];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    return self;
}

- (void)actionCancel {
    [self hide];
}

- (void)actionConfirm {
    _comfirm = YES;
    [self hide];
}

- (void)setDismissCompletion:(void (^)(ATSheetView *, BOOL))completion {
    __weak typeof(self) weakSelf = self;
    [self setHideCompletionBlock:^(MMPopupView *view, BOOL finish) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (completion) {
            completion(strongSelf, strongSelf->_comfirm);
        }
    }];
}
@end
