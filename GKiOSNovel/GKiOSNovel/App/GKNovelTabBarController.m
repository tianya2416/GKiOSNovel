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
@interface GKNovelTabBarController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKNovelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    
    self.listData = @[].mutableCopy;
    self.tabBar.translucent = NO;
    UIViewController *vc = nil;
    vc = [[GKHomeController alloc] init];
    [self vcWithController:vc title:@"首页" normal:@"icon_home_n" select:@"icon_home_h"];
    vc = [[GKClassContentController alloc] init];
    [self vcWithController:vc title:@"分类" normal:@"icon_class_n" select:@"icon_class_h"];
    vc = [[GKMineController alloc] init];
    [self vcWithController:vc title:@"我的" normal:@"icon_mine_n" select:@"icon_mine_h"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
