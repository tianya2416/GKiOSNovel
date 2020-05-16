//
//  BaseNetCache.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseNetCache : NSObject
@property (strong, nonatomic,readonly) YYDiskCache * _Nonnull diskCache;

@property (strong, nonatomic,readonly) YYMemoryCache * _Nonnull memoryCache;

+ (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *_Nonnull)key completion:(void(^_Nonnull)(void))completion;
+ (id _Nonnull )objectForKey:(NSString *_Nonnull)key ;
+ (void)objectForKey:(NSString *_Nonnull)key completion:(void(^)(NSString * _Nonnull key, id<NSCoding> _Nullable object))completion;
+ (void)removeObjectForKey:(NSString *_Nonnull)key completion:(void(^_Nonnull)(NSString * _Nonnull key))completion;
+ (void)removeDiskCache;
+ (CGFloat)diskCacheSize;



+ (void)setMemoryObject:(id _Nonnull )object forkey:(NSString *_Nonnull)key;
+ (id _Nonnull )memoryObjectForKey:(NSString *_Nonnull)key;
+ (void)removeMemory;

@end

