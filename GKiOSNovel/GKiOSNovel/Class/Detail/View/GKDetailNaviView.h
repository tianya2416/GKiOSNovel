//
//  GKDetailNaviView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKDetailNaviView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (void)setAlphas:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
