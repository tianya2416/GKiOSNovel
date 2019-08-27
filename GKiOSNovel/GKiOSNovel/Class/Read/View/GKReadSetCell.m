//
//  GKReadSetCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadSetCell.h"

@implementation GKReadSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 17.5;
    // Initialization code
}

@end
