//
//  BaseCell.m
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

/**
 如果使用xib创建cell 就会调用该方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.imageRg];
        [self.contentView addSubview:self.bottomLine];
        
        [self.imageRg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(self.imageRg.superview);
            make.centerY.equalTo(self.imageRg.superview);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLab.superview).offset(15);
            make.right.equalTo(self.imageRg.mas_left).offset(0);
        }];
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLab);
            make.top.equalTo(self.titleLab.mas_bottom).offset(10);
            make.bottom.equalTo(self.subTitle.superview).offset(-15);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.left.equalTo(self.titleLab);
            make.right.equalTo(self.imageRg);
            make.bottom.equalTo(self.bottomLine.superview);
        }];
    }
    return self;
}

- (UIImageView *)imageRg
{
    if (!_imageRg) {
        _imageRg = [[UIImageView alloc]init];
        _imageRg.image = [UIImage imageNamed:@"icon_my_set_right"];
    }
    return _imageRg;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:16.0f];
        _titleLab.textColor = Appx333333;
        _titleLab.numberOfLines = 1.0f;
    }
    return _titleLab;
}
- (UILabel *)subTitle
{
    if (!_subTitle) {
        _subTitle = [[UILabel alloc]init];
        _subTitle.textAlignment = NSTextAlignmentLeft;
        _subTitle.font = [UIFont systemFontOfSize:14.0f];
        _subTitle.textColor = Appx666666;
        _subTitle.numberOfLines = 2.0f;
    }
    return _subTitle;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = Appxdddddd;
    }
    return _bottomLine;
}

@end
