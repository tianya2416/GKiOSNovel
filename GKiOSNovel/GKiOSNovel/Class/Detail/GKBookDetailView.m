//
//  GKBookDetailView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailView.h"

@implementation GKBookDetailView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentTitleLab.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 25;
    self.imageV.layer.borderWidth = 2.0f;
    self.imageV.layer.borderColor = Appxdddddd.CGColor;
    
    self.lvBtn.layer.masksToBounds = YES;
    self.lvBtn.layer.cornerRadius = AppRadius;
    self.lvBtn.userInteractionEnabled = NO;
    [self.lvBtn setBackgroundColor:AppColor];
}
- (void)setModel:(GKBookListDetailModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageV setGkImageWithURL:_model.author.avatar];
        self.contentTitleLab.text = _model.desc ?:@"";
        self.nickNameLab.text = model.author.nickname ?:@"";
        self.titleLab.text = model.title ?:@"";
        [self.lvBtn setTitle:[NSString stringWithFormat:@"LV %@",@(model.author.lv)] forState:UIControlStateNormal];
    }
}

@end
