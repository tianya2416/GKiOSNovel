//
//  GKStartCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKStartCell.h"

@implementation GKStartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.layer.masksToBounds = YES;
    self.titleLab.layer.cornerRadius = AppRadius;
    self.titleLab.layer.borderWidth = AppLineHeight;
    self.titleLab.layer.borderColor = AppColor.CGColor;
    
    // Initialization code
}

- (void)setModel:(GKRankModel *)model{
    _model = model;
    [self setSelect:model.select];
    self.titleLab.text = model.shortTitle ?:@"";
}
- (void)setSelect:(BOOL)select{
    if (select) {
        self.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.backgroundColor = AppColor;
    }else{
        self.titleLab.layer.borderColor = AppColor.CGColor;
        self.titleLab.backgroundColor = [UIColor whiteColor];
        self.titleLab.textColor = AppColor;
    }
}
@end
