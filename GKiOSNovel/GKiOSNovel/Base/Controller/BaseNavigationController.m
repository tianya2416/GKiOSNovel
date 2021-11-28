//
//  BaseNavigationController.m
//  MyCountDownDay
//
//  Created by wangws1990 on 2019/1/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
//    NSArray *array = [NSArray arrayWithObjects:[self class], nil]; //iOS9.0后使用
//    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:array];
//
//    navBar.titleTextAttributes = attribute;
//    UIImage *backgroundImage = [UIImage imageWithColor:Appxffffff];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage new]];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *imageColor = [UIImage imageWithColor:color];
    UINavigationBar *naviBar = self.navigationBar;
    [naviBar setTranslucent:NO];
    [naviBar setTitleTextAttributes:[self defaultNvi]];
    [naviBar setBackgroundImage:imageColor forBarMetrics:UIBarMetricsDefault];
    naviBar.shadowImage = imageColor;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.shadowColor = color;
        appearance.backgroundImage = imageColor;
        appearance.backgroundColor = color;
        appearance.titleTextAttributes = [self defaultNvi];
        naviBar.scrollEdgeAppearance = appearance;
        naviBar.standardAppearance = appearance;
        naviBar.compactAppearance = appearance;
        naviBar.compactScrollEdgeAppearance = appearance;
    } else {
        // Fallback on earlier versions
    }
    
    
}
- (NSDictionary *)defaultNvi{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = Appx252631;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    return  attribute;
}
#pragma mark UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushing == YES) {
        NSLog(@"被拦截");
        return;
    } else {
        NSLog(@"push");
        self.pushing = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
}
- (BOOL)shouldAutorotate{
    return self.visibleViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.visibleViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
}
- (BOOL)prefersStatusBarHidden {
    return [self.visibleViewController prefersStatusBarHidden];
}
@end
