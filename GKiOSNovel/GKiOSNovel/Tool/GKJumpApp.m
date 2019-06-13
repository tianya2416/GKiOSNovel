//
//  GKJumpApp.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKJumpApp.h"
#import "GKStartViewController.h"
@implementation GKJumpApp
+ (void)jumpToAppGuidePage:(void(^)(void))completion
{
    BOOL res = [GKUserManager alreadySelect];
    if (!res) {
        [GKJumpApp window].rootViewController = [GKStartViewController vcWithCompletion:completion];
    }else
    {
        !completion ?: completion();
    }
}
+  (UIWindow *)window
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }else
    {
        return [app keyWindow];
    }
}
@end
