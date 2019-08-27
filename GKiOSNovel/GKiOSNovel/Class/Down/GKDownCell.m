//
//  GKDownCell.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownCell.h"

@implementation GKDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 4;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(GKDownBookInfo *)info{
    if (_info != info) {
        _info = info;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:placeholders];
        self.titleLab.text = info.title ?:@"";
        self.subTitleLab.text = info.author ?:@"";
        self.detailLab.text = [NSString stringWithFormat:@"已缓存: %@章",@(info.downIndex)];
    }
}
@end
