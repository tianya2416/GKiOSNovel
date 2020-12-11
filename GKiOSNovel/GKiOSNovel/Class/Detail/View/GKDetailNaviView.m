//
//  GKDetailNaviView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKDetailNaviView.h"

@implementation GKDetailNaviView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    [self.backBtn setImage:[UIImage imageNamed:@"icon_detai_back_1"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_detai_back_1"] forState:UIControlStateNormal|UIControlStateHighlighted];
    
    [self.backBtn setImage:[UIImage imageNamed:@"icon_detai_back_2"] forState:UIControlStateSelected];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_detai_back_2"] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self setAlphas:0];
}
- (void)setAlphas:(CGFloat)alpha{
    self.mainView.alpha = alpha;
    self.titleLab.hidden = alpha == 1 ? false : true;
    self.backBtn.selected = alpha > 0.5;
}

@end
