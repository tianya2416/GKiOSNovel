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
    self.tagBtn.layer.masksToBounds = YES;
    self.tagBtn.layer.cornerRadius = 8;
    [self.tagBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x000000 alpha:0.35]] forState:UIControlStateNormal];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = AppRadius;
}
- (void)setModel:(id)object{
    if ([object isKindOfClass:GKBookModel.class]) {
        GKBookModel *model = object;
        [self.imageV setGkImageWithURL:model.cover];
        self.titleLab.text = model.title ?:@"";
        [self.tagBtn setTitle:model.majorCate?:@"" forState:UIControlStateNormal];
        self.nickLab.text = model.author ?: @"";
    }else if ([object isKindOfClass:GKBookListModel.class]){
        GKBookListModel *model = object;
        [self.imageV setGkImageWithURL:model.cover];
        self.titleLab.text = model.title ?:@"";
        self.nickLab.text = model.author ?: @"";
    }
}

@end
