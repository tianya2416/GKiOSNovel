//
//  GKBookDetailTabbar.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailTabbar : UIView
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@property (assign, nonatomic) BOOL collection;

@end

NS_ASSUME_NONNULL_END
