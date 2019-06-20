//
//  BaseNetCache.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseNetCache.h"
static YYDiskCache *_diskCache = nil;
@interface BaseNetCache()
@property (strong, nonatomic) YYDiskCache *diskCache;
@end
@implementation BaseNetCache
+ (void)setObject:(id<NSCoding>)object forKey:(NSString *)key completion:(void (^)(void))completion{
    if (!object || !key) {
        return;
    }
    [BaseNetCache.diskCache setObject:object forKey:key withBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    }];
}
+ (void)objectForKey:(NSString *)key completion:(void (^)(NSString * _Nonnull, id<NSCoding> _Nullable))completion{
    if (!key) {
        return;
    }
    [BaseNetCache.diskCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(key,object);
        });
    }];
}
+ (void)removeObjectForKey:(NSString *)key completion:(void (^)(NSString * _Nonnull))completion{
    if (!key ) {
        return;
    }
    [BaseNetCache.diskCache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(key);
        });
    }];
}
+ (void)removeDiskCache{
    [BaseNetCache.diskCache removeAllObjectsWithBlock:^{
        NSLog(@"removeDiskCache success");
    }];
}
+ (CGFloat)diskCacheSize{
    CGFloat size = [BaseNetCache.diskCache totalCost] / 1024.0 / 1024.0;
    return size;
}
#pragma mark get
+ (YYDiskCache *)diskCache
{
    if (!_diskCache) {
        NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Caches"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        //NSString *stringPath =[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.todayClock"] absoluteString];
        _diskCache = [[YYDiskCache alloc] initWithPath:path];
    }
    return _diskCache;
}
@end
