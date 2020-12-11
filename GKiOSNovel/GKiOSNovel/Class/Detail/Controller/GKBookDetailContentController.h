//
//  GKBookDetailContentController.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YNPageViewController.h>
NS_ASSUME_NONNULL_BEGIN

@interface GKBookDetailContentController : YNPageViewController
+ (instancetype)vcWithConfig:(NSString *)bookId;
@end

NS_ASSUME_NONNULL_END
