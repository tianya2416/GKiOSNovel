//
//  GKJumpApp.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKJumpApp.h"
#import "GKStartViewController.h"
#import "GKBookDetailController.h"
#import "GKBookListDetailController.h"
#import "GKMineSelectController.h"
#import "GKReadViewController.h"
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
+ (void)jumpToBookDetail:(NSString *)bookId{
    UIViewController *nvc = [UIViewController rootTopPresentedController];
    GKBookDetailController *vc = [GKBookDetailController vcWithBookId:bookId];
    vc.hidesBottomBarWhenPushed = YES;
    NSArray <UIViewController *>*list =  nvc.navigationController.viewControllers;
    NSMutableArray *vcs = @[].mutableCopy;
    [list enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:GKBookDetailController.class]) {
            [vcs addObject:obj];
        }
    }];
    [vcs addObject:vc];
    [nvc.navigationController setViewControllers:vcs animated:YES];
   // [nvc.navigationController pushViewController:vc animated:YES];
}
+ (void)jumpToBookListDetail:(NSString *)bookId{
    UIViewController *nvc = [UIViewController rootTopPresentedController];
    GKBookListDetailController *vc = [GKBookListDetailController vcWithBookId:bookId];
    vc.hidesBottomBarWhenPushed = YES;
    NSArray <UIViewController *>*list =  nvc.navigationController.viewControllers;
    NSMutableArray *vcs = @[].mutableCopy;
    [list enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:GKBookListDetailController.class]) {
            [vcs addObject:obj];
        }
    }];
    [vcs addObject:vc];
    [nvc.navigationController setViewControllers:vcs animated:YES];
}
+ (void)jumpToAddSelect{
    UIViewController *nvc = [UIViewController rootTopPresentedController];
    GKMineSelectController *vc = [[GKMineSelectController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [nvc.navigationController pushViewController:vc animated:YES];
}
+ (void)jumpToReadBook:(NSString *)bookId{
    UIViewController *nvc = [UIViewController rootTopPresentedController];
    GKReadViewController *vc = [[GKReadViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [nvc presentViewController:vc animated:NO completion:nil];
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
