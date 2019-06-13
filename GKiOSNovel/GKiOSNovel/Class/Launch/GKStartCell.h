//
//  GKStartCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKRankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKStartCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic)GKRankModel *model;

@end

NS_ASSUME_NONNULL_END
