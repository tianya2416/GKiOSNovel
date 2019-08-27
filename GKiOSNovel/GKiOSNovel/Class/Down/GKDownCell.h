//
//  GKDownCell.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDownBookInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (strong, nonatomic) GKDownBookInfo *info;

@end

NS_ASSUME_NONNULL_END
