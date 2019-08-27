//
//  GKDownLoadCell.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDownBookInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKDownLoadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) GKDownBookInfo *info;
//状态
@property (assign, nonatomic) GKDownTaskState state;
//进度条
@property (assign, nonatomic) NSInteger progress;
@end

NS_ASSUME_NONNULL_END
