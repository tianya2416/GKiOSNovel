//
//  GKHomeReusableView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeReusableView.h"

@implementation GKHomeReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.superview).offset(15);
        make.baseline.equalTo(self.titleLab.superview).offset(-5);
    }];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(self.moreBtn.superview).offset(-15);
        make.bottom.equalTo(self.titleLab.mas_baseline);
        make.height.offset(25);
    }];

    self.moreBtn.layer.masksToBounds = true;
    self.moreBtn.layer.cornerRadius = 12.5;
    self.moreBtn.layer.borderWidth = 0.8;
    self.moreBtn.layer.borderColor = AppColor.CGColor;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_moreBtn setTitleColor:AppColor forState:UIControlStateNormal];
        _moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _moreBtn;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:20.0f weight:UIFontWeightHeavy];
        _titleLab.textColor  = Appx252631;
    }
    return _titleLab;
}
@end
