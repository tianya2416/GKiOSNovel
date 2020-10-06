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
        make.left.equalTo(self.titleLab.superview).offset(AppTop);
        make.centerY.equalTo(self.titleLab.superview).offset(0);
    }];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(self.moreBtn.superview).offset(-10);
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.lineView.superview);
        make.height.offset(0.5);
    }];
    self.lineView.hidden = YES;

}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_moreBtn setTitleColor:Appx999999 forState:UIControlStateNormal];
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
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Appxdddddd;
    }
    return _lineView;
}
@end
