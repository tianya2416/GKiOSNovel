//
//  GKClassflyCell.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKClassflyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (strong, nonatomic)GKBookModel *model;

@end

NS_ASSUME_NONNULL_END
