//
//  GKClassifyHotCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/9/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKClassifyHotCell.h"

@implementation GKClassifyHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = AppRadius;
    // Initialization code
}
- (void)setModel:(id)object{
    if ([object isKindOfClass:GKClassItemModel.class]){
        GKClassItemModel *model = object;
        [self.imageV setGkImageWithURL:model.icon];
        self.titleLab.text = model.name ?:@"";
    }
}
@end
