//
//  GKReadTopView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKReadTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
