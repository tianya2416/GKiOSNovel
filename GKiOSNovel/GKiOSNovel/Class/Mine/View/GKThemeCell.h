//
//  GKThemeCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKAppModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKThemeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) GKAppModel *model;
@end

NS_ASSUME_NONNULL_END
