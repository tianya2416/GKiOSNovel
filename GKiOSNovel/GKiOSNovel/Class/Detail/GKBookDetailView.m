//
//  GKBookDetailView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailView.h"

@implementation GKBookDetailView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentTitleLab.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
}
- (void)setModel:(GKBookDetailModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageV setGkImageWithURL:_model.cover];
        self.contentTitleLab.text = _model.longIntro ?:@"";
    }
}

@end
