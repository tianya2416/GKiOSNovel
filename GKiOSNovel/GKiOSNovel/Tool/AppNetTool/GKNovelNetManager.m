//
//  GKSoneNetManager.m
//  GKSongApp
//
//  Created by wangws1990 on 2019/6/5.
//  Copyright © 2019 王炜圣. All rights reserved.
//

#import "GKNovelNetManager.h"
#import "BaseNetManager.h"
@implementation GKNovelNetManager
+ (void)rankSuccess:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
     [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"ranking/gender") params:nil success:success failure:failure];
}
+ (void)homeHot:(NSString *)rankId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure
{
    NSString *url = [NSString stringWithFormat:@"ranking/%@",rankId?:@"5a6844aafc84c2b8efaa6b6e"];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:nil success:^(id object) {
        !success ?: success(object[@"ranking"]);
    } failure:failure];
}

+ (void)homeClass:(NSString *)category success:(void(^)(id object))success failure:(void(^)(NSString *error))failure
{
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"cats/lv2/statistics") params:nil success:^(id object) {
        !success ?: success(object[category?:@""]);
    } failure:failure];
}
+ (void)homeClssItem:(NSString *)group major:(NSString *)major page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{
                            @"gender":group ?:@"",
                            @"type":@"hot",
                            @"major":major ?:@"",
                            @"minor":@"",
                            @"start":@(page),
                            @"limit":@(RefreshPageSize)
                            };
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"book/by-categories") params:params success:success failure:failure];
}
+ (void)homeSearch:(NSString *)hotWord page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{
                             @"query":hotWord ?:@"",
                             @"start":@(page-1),//服务器接口要求
                             @"limit":@(RefreshPageSize)
                             };
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"book/fuzzy-search") params:params success:success failure:failure];
}
+ (void)bookDetail:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"book/%@",bookId?:@""];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:nil success:success failure:failure];
}
//推荐列表
+ (void)bookCommend:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"book/%@/recommend",bookId?:@""];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:nil success:success failure:failure];
}
//推荐书单
+ (void)bookListCommend:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"book-list/%@/recommend",bookId?:@""];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:nil success:success failure:failure];
}
//推荐书单详情
+ (void)bookListDetail:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"book-list/%@/",bookId?:@""];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:nil success:success failure:failure];
}
//书源
+ (void)bookSummary:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{
                             @"book":bookId ?:@"",
                             @"view":@"summary",
                             };
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"toc") params:params cache:YES success:success failure:failure];
}
+ (void)bookChapters:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{
                             @"view":@"chapters",
                             };
    
    NSString *url = [NSString stringWithFormat:@"toc/%@",bookId?:@""];
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(url) params:params cache:YES success:success failure:failure];
}
+ (void)bookContent:(NSString *)url success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
   url = [url stringByURLEncode];
   NSString * urlStr = [NSString stringWithFormat:@"https://chapter2.zhuishushenqi.com/chapter/%@",url];
   [BaseNetManager method:HttpMethodGet urlString:urlStr params:nil cache:YES success:success failure:failure];
}
+ (void)updateContent:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{@"id":bookId?:@"",
                             @"view":@"updated",
                             };
    [BaseNetManager method:HttpMethodGet urlString:kBaseUrl(@"book") params:params success:success failure:failure];
}
@end
