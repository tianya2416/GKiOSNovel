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
        make.centerY.equalTo(self.titleLab.superview);
    }];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(self.moreBtn.superview).offset(-10);
        make.centerY.equalTo(self.titleLab);
    }];

}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_moreBtn setTitleColor:AppColor forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"icon_home_more"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _titleLab.textColor  = Appx252631;
    }
    return _titleLab;
}
@end
