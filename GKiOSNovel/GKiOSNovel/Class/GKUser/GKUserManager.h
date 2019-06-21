//
//  GKUserManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKUserManager : NSObject
@property (strong, nonatomic,readonly) GKUserModel *user;


+ (instancetype)shareInstance;
+ (BOOL)saveUserModel:(GKUserModel *)user;
+ (BOOL)alreadySelect;

+ (void)reloadHomeData:(GKLoadDataState)option;
+ (void)reloadHomeDataNeed:(void(^)(GKLoadDataState option))completion;
@end

NS_ASSUME_NONNULL_END
