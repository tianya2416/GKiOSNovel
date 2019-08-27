//
//  GKDownHeadView.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownHeadView.h"

@implementation GKDownHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.moreBtn.layer.masksToBounds = YES;
    self.moreBtn.layer.cornerRadius = 12.5f;
}

@end
