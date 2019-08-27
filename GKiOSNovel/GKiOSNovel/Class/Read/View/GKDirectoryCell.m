//
//  GKDirectoryCell.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDirectoryCell.h"

@implementation GKDirectoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = self.contentView.backgroundColor = Appxffffff;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSelect:(BOOL)select{
    _select = select;
    self.titleLab.textColor = select ? AppColor : Appx333333;
}
@end
