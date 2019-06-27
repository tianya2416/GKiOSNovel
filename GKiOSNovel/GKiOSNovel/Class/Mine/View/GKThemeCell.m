//
//  GKThemeCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKThemeCell.h"

@implementation GKThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKAppModel *)model{
    _model = model;
    self.imageV.image = [UIImage imageWithColor:[UIColor colorWithHexString:model.color]];
    self.titleLab.text = model.title ?:@"";
    GKAppModel *modelq = [GKAppTheme shareInstance].model;
    self.imageIcon.hidden = ![model.title isEqualToString:modelq.title];
}
@end
