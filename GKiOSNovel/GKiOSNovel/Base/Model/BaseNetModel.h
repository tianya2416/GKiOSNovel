//
//  BaseNetModel.h
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface BaseNetModel : BaseModel
#pragma mark -

/**
 *  请求URL(主要用于调试)
 */
@property(nonatomic, copy ) NSString * requestUrl;  //请求URL
/**
 *  请求参数(主要用于调试)
 */
@property(nonatomic,strong)NSDictionary *params;  //请求参数
/**
 *  请求头参数(主要用于调试)
 */
@property(nonatomic,strong)NSDictionary *headParams;  //请求头参数
//所有数据
@property(nonatomic, strong)NSDictionary *allResultData;
//返回码
@property(nonatomic,assign)NSInteger ok;
//错误消息
@property(nonatomic, copy )NSString *msg;
//具体数据(一般是Dictionary或Array)
@property(nonatomic,strong)id resultset;

- (BOOL)isDataSuccess;
- (BOOL)isNetError;

+ (instancetype)successModel:(id)response
                   urlString:(NSString *)urlString
                      params:(NSDictionary *)params
                  headParams:(NSDictionary *)headParams;
+ (instancetype)netErrorModel:(NSString *)error;
+ (NSDictionary *)analysisData:(id)response;
+ (NSString *)analysisError:(NSError *)error;
@end


