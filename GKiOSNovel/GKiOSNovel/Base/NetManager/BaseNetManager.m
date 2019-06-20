//
//  BaseNetWorkManager.m
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseNetManager.h"
#import "BaseNetCache.h"
static BOOL AFRequest = YES;
@implementation BaseNetManager
- (void)dealloc
{
    NSLog(@"Class %@ is dealloc",[self class]);
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    return [BaseNetManager method:method urlString:urlString params:params cache:NO success:success failure:failure];
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                           cache:(BOOL)cache
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    NSString *key = [NSString stringWithFormat:@"%@%@%@",urlString,params ?@"?":@"",AFQueryStringFromParameters(params)];
    __block NSURLSessionDataTask * task = nil;
    void(^netManager)(void) = ^{
        task = [BaseNetManager method:method serializer:HttpSerializeDefault urlString:urlString params:params success:^(id object) {
            BaseNetModel *model = [BaseNetModel successModel:object urlString:urlString params:params headParams:nil];
            if ([model isDataSuccess]) {
                if (cache) {
                    [BaseNetCache setObject:model.resultset forKey:key completion:^{
                        
                    }];
                }
                !success ?: success(model.resultset);
            }else{
                !failure ?: failure(model.msg);
            }
        } failure:^(NSString *error) {
            !failure ?: failure(error);
        }];
    };
    if (cache) {
        [BaseNetCache objectForKey:key completion:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
            if (object) {
                !success ?: success(object);
            }else{
                netManager();
            }
        }];
    }else{
        netManager();
    }
    return task;
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    return [BaseNetManager method:method serializer:serializer urlString:urlString params:params timeOut:10.0f success:success failure:failure];
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         timeOut:(NSTimeInterval)timeOut
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    if (AFRequest) {
        return [AFRequestTool method:method serializer:serializer urlString:urlString params:params timeOut:timeOut success:^(id  _Nonnull object) {
            NSDictionary *dic = [BaseNetModel analysisData:object];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dic) {
                    
                }
                !success ?: success(dic);
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !failure ?: failure([BaseNetModel analysisError:error]);
            });
        }];
    }
    return [SectionTool method:method serializer:serializer urlString:urlString params:params timeOut:timeOut success:^(id  _Nonnull object) {
        NSDictionary *dic = [BaseNetModel analysisData:object];
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ?: success(dic);
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !failure ?: failure([BaseNetModel analysisError:error]);
        });
    }];
}

@end
