//
//  BaseNetCache.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNetCache : NSObject
@property (strong, nonatomic,readonly) YYDiskCache *diskCache;

@property (strong, nonatomic,readonly) YYMemoryCache *memoryCache;

+ (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key completion:(void(^)(void))completion;
+ (id)objectForKey:(NSString *)key ;
+ (void)objectForKey:(NSString *)key completion:(void(^)(NSString *key, id<NSCoding> _Nullable object))completion;
+ (void)removeObjectForKey:(NSString *)key completion:(void(^)(NSString *key))completion;
+ (void)removeDiskCache;
+ (CGFloat)diskCacheSize;


+ (void)setMemoryObject:(id)object forkey:(NSString *)key;
+ (id)memoryObjectForKey:(NSString *)key;
+ (void)removeMemory;
@end

NS_ASSUME_NONNULL_END
