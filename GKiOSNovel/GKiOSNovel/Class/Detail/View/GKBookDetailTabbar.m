//
//  GKBookDetailTabbar.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailTabbar.h"

@implementation GKBookDetailTabbar
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.addBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.addBtn setTitle:@"收藏" forState:UIControlStateNormal|UIControlStateHighlighted];
    
    [self.addBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [self.addBtn setTitle:@"已收藏" forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.readBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
    [self.addBtn setTitleColor:AppColor forState:UIControlStateNormal];
    [self.addBtn setTitleColor:Appx999999 forState:UIControlStateSelected];
}
- (void)setCollection:(BOOL)collection{
    if (_collection != collection) {
        _collection = collection;
        self.addBtn.selected = collection;
    }
}
@end
