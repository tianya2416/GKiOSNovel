//
//  GKBookDetaiContentCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetaiContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic)GKBookDetailModel *model;
@end

NS_ASSUME_NONNULL_END
