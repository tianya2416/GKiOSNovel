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
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(self.moreBtn.superview).offset(-15);
        make.bottom.equalTo(self.titleLab.mas_bottom);
    }];
}
- (ATImageRightButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [ATImageRightButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"icon_home_more"] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.imageMarning = 0;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_moreBtn setTitleColor:AppColor forState:UIControlStateNormal];
    }
    return _moreBtn;
}
@end
