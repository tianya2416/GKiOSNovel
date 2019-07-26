//
//  UIViewController+Tool.m
//  GKiOSGame
//
//  Created by wangws1990 on 2019/7/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "UIViewController+Tool.h"

@implementation UIViewController (Tool)
- (void)setOrientations:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    [UIApplication sharedApplication].statusBarOrientation = orientation;
//#pragma clang diagnostic pop
}
@end
