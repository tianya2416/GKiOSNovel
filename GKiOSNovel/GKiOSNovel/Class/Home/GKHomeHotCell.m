//
//  GKHomeHotCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeHotCell.h"

@implementation GKHomeHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.contentView.layer.masksToBounds =self.imageV.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = self.imageV.layer.cornerRadius = 5.0f;
//    self.contentView.backgroundColor = [UIColor colorWithRGB:0xffffff];
    self.tagBtn.layer.masksToBounds = YES;
    self.tagBtn.layer.cornerRadius = 10;
    [self.tagBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x000000 alpha:0.35]] forState:UIControlStateNormal];
    
    // Initialization code
}
- (void)setModel:(id)object{
    if ([object isKindOfClass:GKBookModel.class]) {
        GKBookModel *model = object;
        [self.imageV setGkImageWithURL:model.cover];
        self.titleLab.text = model.title ?:@"";
        [self.tagBtn setTitle:model.majorCate?:@"" forState:UIControlStateNormal];
    }else if ([object isKindOfClass:GKClassItemModel.class]){
        GKClassItemModel *model = object;
        [self.imageV setGkImageWithURL:model.icon];
        self.titleLab.text = model.name ?:@"";
        [self.tagBtn setTitle:[NSString stringWithFormat:@"月票:%@",model.monthlyCount ?:@""] forState:UIControlStateNormal];
    }
}

@end
