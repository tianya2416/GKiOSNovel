//
//  GKReadTopView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadTopView.h"

@implementation GKReadTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.addBtn.backgroundColor = AppColor;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 5;
}
- (IBAction)goBack:(id)sender {
    if ([self.delegate respondsToSelector:@selector(readTopView:goBack:)]) {
        [self.delegate readTopView:self goBack:YES];
    }
}
- (IBAction)downAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(readTopView:down:)]) {
        [self.delegate readTopView:self down:YES];
    }
}
- (IBAction)nativeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(readTopView:native:)]) {
        [self.delegate readTopView:self native:sender.selected];
    }
}

@end
