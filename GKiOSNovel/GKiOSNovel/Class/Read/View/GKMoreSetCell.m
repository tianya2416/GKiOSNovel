//
//  GKMoreSetCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMoreSetCell.h"

@implementation GKMoreSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = self.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
