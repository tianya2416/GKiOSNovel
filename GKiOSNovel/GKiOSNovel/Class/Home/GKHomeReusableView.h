//
//  GKHomeReusableView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKHomeReusableView : UICollectionReusableView
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) ATImageRightButton *moreBtn;

@end

NS_ASSUME_NONNULL_END
