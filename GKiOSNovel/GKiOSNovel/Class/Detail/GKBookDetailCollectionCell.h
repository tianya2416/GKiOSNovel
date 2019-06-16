//
//  GKBookDetailCollectionCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *counLab;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (strong, nonatomic) GKBookListModel *model;

@end

NS_ASSUME_NONNULL_END
