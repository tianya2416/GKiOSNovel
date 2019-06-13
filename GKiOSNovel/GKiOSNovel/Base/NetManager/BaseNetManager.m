//
//  BaseNetWorkManager.m
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseNetManager.h"
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
    return [BaseNetManager method:method serializer:HttpSerializeDefault urlString:urlString params:params success:^(id object) {
        BaseNetModel *model = [BaseNetModel successModel:object urlString:urlString params:params headParams:nil];
        if ([model isDataSuccess]) {
            !success ?: success(model.resultset);
        }else{
            !failure ?: failure(model.msg);
        }
    } failure:^(NSString *error) {
        !failure ?: failure(error);
    }];
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
