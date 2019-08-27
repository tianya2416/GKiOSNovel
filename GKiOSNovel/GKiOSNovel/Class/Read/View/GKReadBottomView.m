//
//  GKReadBottomView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadBottomView.h"
#import "GKReadSetView.h"
@implementation GKReadBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.slider.thumbTintColor = AppColor;
    self.slider.minimumTrackTintColor = AppColor;
    self.slider.maximumTrackTintColor = [UIColor colorWithRGB:0xe8e8e8];
    UIImage *image  = [GKReadSetView circleImageWithName:[GKReadSetView originImage:[UIImage imageWithColor:AppColor] scaleToSize:CGSizeMake(5, 5)] borderWidth:6 borderColor:[UIColor colorWithRGB:0xf8f8f8]];
    [self.slider setThumbImage:image forState:UIControlStateNormal];
    [self.slider setThumbImage:image forState:UIControlStateHighlighted];
    
    [self.slider addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(outsideAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.dayBtn addTarget:self action:@selector(dayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.setBtn addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cataBtn addTarget:self action:@selector(cataAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastBtn addTarget:self action:@selector(lastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    GKSet *model = [GKSetManager shareInstance].model;
    self.dayBtn.selected = model.night;
}
- (void)touchUpAction:(UISlider *)slider{
    
}
- (void)changedAction:(UISlider *)slder{

}
- (void)outsideAction:(UISlider *)slder{
    NSInteger brightness = slder.value;
    NSInteger max = slder.maximumValue;
    NSLog(@"%@",@(brightness));
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@/%@",@(brightness+1),@(max+1)] toView:self];
    if ([self.delegate respondsToSelector:@selector(bottomView:page:)]) {
        [self.delegate bottomView:self page:brightness];
    }
}
- (void)dayAction:(UIButton *)slder{
    slder.selected = !slder.selected;
    if ([self.delegate respondsToSelector:@selector(bottomView:day:)]) {
        [self.delegate bottomView:self day:!slder.selected];
    }
}
- (void)setAction:(UIButton *)slder{
    if ([self.delegate respondsToSelector:@selector(bottomView:set:)]) {
        [self.delegate bottomView:self set:YES];
    }
}
- (void)cataAction:(UIButton *)slder{
    if ([self.delegate respondsToSelector:@selector(bottomView:cata:)]) {
        [self.delegate bottomView:self cata:YES];
    }
}
- (void)lastAction:(UIButton *)slder{
    if ([self.delegate respondsToSelector:@selector(bottomView:last:)]) {
        [self.delegate bottomView:self last:YES];
    }
}
- (void)nextAction:(UIButton *)slder{
    if ([self.delegate respondsToSelector:@selector(bottomView:last:)]) {
        [self.delegate bottomView:self last:NO];
    }
}
@end
