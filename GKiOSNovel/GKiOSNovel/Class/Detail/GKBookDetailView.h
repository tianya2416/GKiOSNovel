//
//  GKBookDetailView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLab;

@property (strong, nonatomic) GKBookDetailModel *model;

@end

NS_ASSUME_NONNULL_END
