//
//  GKJumpApp.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKJumpApp : NSObject
+ (void)jumpToAppGuidePage:(void(^)(void))completion;
+ (void)jumpToBookDetail:(NSString *)bookId;
+ (void)jumpToBookListDetail:(NSString *)bookId;
+ (void)jumpToAddSelect;
+ (void)jumpToBookRead:(GKBookDetailModel *)model;
+ (void)jumpToBookCase;
+ (void)jumpToBookHistory;
+ (void)jumpToAppTheme;
@end
NS_ASSUME_NONNULL_END
