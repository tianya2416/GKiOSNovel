//
//  BaseNetTool.h
//  YiCong
//
//  Created by wangws1990 on 2019/4/12.
//  Copyright © 2019 王炜圣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethodGet = 0,
    HttpMethodPost,
    HttpMethodPut,
    HttpMethodDelete,
};
typedef NS_ENUM(NSInteger, HttpSerializer) {
    HttpSerializeDefault      = 0,//默认 编码方式:mid=10&method=userInfo
    HttpSerializeJSON         = 1,//json 编码方式:{"mid":"11","method":"userInfo"}
    HttpSerializePropertyList = 2,//plist
};
@protocol BaseNetToolObject <NSObject>
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         timeOut:(NSTimeInterval)timeOut
                         success:(void(^)(id object))success
                         failure:(void(^)(NSError *error))failure;

@end
@interface AFRequestTool : NSObject<BaseNetToolObject>

@end

@interface SectionTool : NSObject<NSURLSessionDelegate,BaseNetToolObject>

@end
NS_ASSUME_NONNULL_END
