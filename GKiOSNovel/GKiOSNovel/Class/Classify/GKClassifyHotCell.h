//
//  GKClassifyHotCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/9/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKClassifyHotCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) id model;
@end

NS_ASSUME_NONNULL_END
