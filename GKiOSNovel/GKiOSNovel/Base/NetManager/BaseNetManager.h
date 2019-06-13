//
//  BaseNetWorkManager.h
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseNetTool.h"
#import "BaseNetModel.h"

@interface BaseNetManager : NSObject

+ (NSURLSessionDataTask *)method:(HttpMethod)method
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure;
/**
 @brief 网络请求方式
 @param method 包含各种请求 get post put 等
 @param serializer 包含各种请求 json uncode 等
 @param urlString 服务端地址
 @param params 参数
 @param timeOut 超时
 @param success 成功回调
 @param failure 失败回调
 */
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         timeOut:(NSTimeInterval)timeOut
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure;
@end
