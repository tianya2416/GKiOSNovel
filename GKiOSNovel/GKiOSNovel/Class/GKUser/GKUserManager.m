//
//  GKUserManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKUserManager.h"
static NSString *gkUser = @"gkUser";
@interface GKUserManager()
@property (strong, nonatomic) GKUserModel *user;
@property (copy, nonatomic) void(^completion)(GKLoadDataState option);
@end
@implementation GKUserManager
+ (instancetype)shareInstance {
    static GKUserManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareInstance) {
            _shareInstance = [[[self class] alloc]init];
        }
    });
    return _shareInstance;
}
/**
 *  写入当前用户
 */
+ (BOOL)saveUserModel:(GKUserModel *)user
{
    [GKUserManager shareInstance].user = user;
    BOOL res = NO;
    NSData *userData = [BaseModel archivedDataForData:user];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:gkUser];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
- (GKUserModel *)user
{
    if (!_user) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkUser];
        _user = data ? [BaseModel unarchiveForData:data]: nil;
    }
    return _user;
}
+ (BOOL)alreadySelect{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:gkUser];
    return object;
}
+ (void)reloadHomeData:(GKLoadDataState)option{
    ![GKUserManager shareInstance].completion ?: [GKUserManager shareInstance].completion(option);
}
+ (void)reloadHomeDataNeed:(void(^)(GKLoadDataState option))completion{
    [GKUserManager shareInstance].completion = completion;
}
@end
