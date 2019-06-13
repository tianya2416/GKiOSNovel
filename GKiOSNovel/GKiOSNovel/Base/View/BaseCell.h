//
//  BaseCell.h
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

//标题
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * subTitle;
//右侧图标
@property (strong, nonatomic) UIImageView * imageRg;
//底部线
@property (strong, nonatomic) UIView * bottomLine;

@end
