//
//  GKBookDetailCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailCell.h"

@implementation GKBookDetailCell
+ (CGFloat)heightForWidth:(CGFloat)width model:(GKBookDetailModel *)model
{
    if (model.height > 0) {
        return model.height;
    }
    static GKBookDetailCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GKBookDetailCell" owner:self options:nil] firstObject];
    });
    cell.model = model;
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width];
    [cell.contentView addConstraint:widthFenceConstraint];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
    return height;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.moreBtn.layer.masksToBounds = self.stateBtn.layer.masksToBounds = YES;
    self.moreBtn.layer.cornerRadius = 10;
    self.stateBtn.layer.cornerRadius = 10.0f;
    [self.moreBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
    self.nickNameLab.textColor = AppColor;
    
}
- (void)setModel:(GKBookDetailModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageV setGkImageWithURL:model.cover];
        self.contentLab.text = model.longIntro ?:@"";
        self.titleLab.text = [NSString stringWithFormat:@"%@(%@)",model.title ?:@"",!model.isSerial?@"完结":@"连载"];
        self.nickNameLab.text = model.author ?:@"";
        self.subTitleLab.text = model.minorCate ?:@"";
        
        self.wordLab.text = [NSString stringWithFormat:@"字数:%@",[@(model.wordCount) decimalString]];
        self.detailTitleLab.text = [NSString stringWithFormat:@"章节数:%@",@(model.chaptersCount)];
        [self.moreBtn setTitle:[NSString stringWithFormat:@"关注度:%.2f%@",model.retentionRatio,@"%"] forState:UIControlStateNormal];
        [self.stateBtn setTitle:model.majorCate forState:UIControlStateNormal];
    }
}
@end
