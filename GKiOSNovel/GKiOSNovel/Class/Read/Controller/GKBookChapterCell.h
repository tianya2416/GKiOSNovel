//
//  GKBookChapterCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKBookChapterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

NS_ASSUME_NONNULL_END
