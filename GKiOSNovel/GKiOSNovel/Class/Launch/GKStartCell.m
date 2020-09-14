//
//  GKStartCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKStartCell.h"
@interface GKStartCell()
@property (assign, nonatomic) GKStartState startState;
@end
@implementation GKStartCell
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                           startState:(GKStartState)startState{
    GKStartCell *cell = [GKStartCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.startState = startState;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.layer.masksToBounds = YES;
    self.titleLab.layer.cornerRadius = AppRadius;
    // Initialization code
}
- (void)setModel:(GKRankModel *)model{
    _model = model;
    [self setSelect:model.select];
    self.titleLab.text = model.shortTitle ?:@"";
}
- (void)setSelect:(BOOL)select{
    if (select) {
        self.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.backgroundColor = AppColor;
    }else{
        self.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
        self.titleLab.backgroundColor = [UIColor colorWithRGB:0xededed];
        self.titleLab.textColor = Appx999999;
    }
}
- (void)setStartState:(GKStartState)startState{
    _startState = startState;
    switch (_startState) {
        case GKStartStateDefault:
             [self setSelect:NO];
            break;
        case GKStartStateBack:
            [self setSelect:YES];
            break;
        default:
            [self setSelect:NO];
            self.contentView.layer.masksToBounds = YES;
            self.contentView.layer.cornerRadius = 12;
         break;
    }
}
@end
