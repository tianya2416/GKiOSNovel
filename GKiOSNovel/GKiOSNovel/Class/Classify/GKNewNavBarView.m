//
//  GKNewNavBarView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewNavBarView.h"

@implementation GKNewNavBarView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.cornerRadius = AppRadius;
}

@end
