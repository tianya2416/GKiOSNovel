//
//  GKDirectoryCell.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKDirectoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (assign, nonatomic) BOOL select;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;

@end

NS_ASSUME_NONNULL_END
