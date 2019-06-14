//
//  GKSoneNetManager.h
//  GKSongApp
//
//  Created by wangws1990 on 2019/6/5.
//  Copyright © 2019 王炜圣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKNovelNetManager : NSObject

+ (void)rankSuccess:(void(^)(id object))success failure:(void(^)(NSString *error))failure;

+ (void)homeHot:(NSString *)rankId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;

+ (void)homeClass:(NSString *)group success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
+ (void)homeClssItem:(NSString *)key major:(NSString *)major page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;

+ (void)homeSearch:(NSString *)hotWord page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;

+ (void)bookDetail:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
