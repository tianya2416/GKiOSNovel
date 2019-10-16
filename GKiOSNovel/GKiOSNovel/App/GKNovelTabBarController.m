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
    GKHomeController *home = [[GKHomeController alloc] init];
    [self vcWithController:home title:@"首页" normal:model.icon_home_n select:model.icon_home_h];
    GKClassContentController *class = [[GKClassContentController alloc] init];
    [self vcWithController:class title:@"分类" normal:model.icon_class_n select:model.icon_class_h];
    GKBooCaseController *book   = [[GKBooCaseController alloc] init];
    [self vcWithController:book title:@"书架" normal:model.icon_case_n select:model.icon_case_h];
    GKMineController *mine = [[GKMineController alloc] init];
    [self vcWithController:mine title:@"我的" normal:model.icon_mine_n select:model.icon_mine_h];
    self.viewControllers = self.listData;
}
- (void)vcWithController:(UIViewController *)vc
                   title:(NSString *)title
                  normal:(NSString *)normal
                  select:(NSString *)select{
    BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [vc showNavTitle:title backItem:NO];
    nv.tabBarItem.title = title;
    nv.tabBarItem.image = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nv.tabBarItem.selectedImage = [[UIImage imageNamed:select] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Appx999999} forState:UIControlStateNormal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
    self.tabBar.tintColor = AppColor;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = Appx999999;
    } else {
        // Fallback on earlier versions
    }
    if (nv) {
        [self.listData addObject:nv];
    }
    
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
