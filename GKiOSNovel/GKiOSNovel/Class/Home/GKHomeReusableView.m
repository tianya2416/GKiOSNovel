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
    }];
}
- (ATImageRightButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [ATImageRightButton buttonWithType:UIButtonTypeCustom];
        GKAppModel *model = [GKAppTheme shareInstance].model;
        [_moreBtn setImage:[UIImage imageNamed:model.icon_more] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.imageMarning = 0;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_moreBtn setTitleColor:AppColor forState:UIControlStateNormal];
    }
    return _moreBtn;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:28.0f weight:UIFontWeightHeavy];
        _titleLab.textColor  = Appx252631;
    }
    return _titleLab;
}
@end
