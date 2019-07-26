//
//  GKNovelTabBarController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNovelTabBarController.h"
#import "GKClassContentController.h"
#import "GKHomeController.h"
#import "GKMineController.h"
#import "GKBooCaseController.h"
@interface GKNovelTabBarController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKNovelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    GKAppModel *model = [GKAppTheme shareInstance].model;
    self.listData = @[].mutableCopy;
    self.tabBar.translucent = NO;
    UIViewController *vc = nil;
    vc = [[GKHomeController alloc] init];
    [self vcWithController:vc title:@"首页" normal:model.icon_home_n select:model.icon_home_h];
    vc = [[GKClassContentController alloc] init];
    [self vcWithController:vc title:@"分类" normal:model.icon_class_n select:model.icon_class_h];
    vc = [[GKBooCaseController alloc] init];
    [self vcWithController:vc title:@"书架" normal:model.icon_case_n select:model.icon_case_h];
    vc = [[GKMineController alloc] init];
    [self vcWithController:vc title:@"我的" normal:model.icon_mine_n select:model.icon_mine_h];
    self.viewControllers = self.listData;
}
- (void)vcWithController:(UIViewController *)vc title:(NSString *)title normal:(NSString *)normal select:(NSString *)select{
    BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [vc showNavTitle:title backItem:NO];
    nv.tabBarItem.title = title;
    nv.tabBarItem.image = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nv.tabBarItem.selectedImage = [[UIImage imageNamed:select] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]} forState:UIControlStateNormal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
    [self.listData addObject:nv];
}
////是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
- (BOOL)prefersStatusBarHidden {
    return [self.selectedViewController prefersStatusBarHidden];
}
@end
