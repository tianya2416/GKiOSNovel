//
//  GKShareTool.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GKShareType) {
    GKShareTypeWechat = 0,
    GKShareTypeWechatLine,
    GKShareTypeQQ,
    GKShareTypeQQZone,
};
NS_ASSUME_NONNULL_BEGIN

@interface GKShareTool : NSObject
#pragma mark 初始化
+ (void)shareInit;
#pragma mark 客户端分享
+ (void)shareTo:(GKShareType)type
       imageUrl:(NSString *)imageUrl
          title:(NSString *)title
       subTitle:(NSString *)subTitle
     completion:(void(^)(NSString *error))completion;
+ (void)shareType:(GKShareType)type
              url:(NSString *)url
            title:(NSString *)title
         subTitle:(NSString *)subTitle
      compeletion:(void(^)(NSString *error))completion;
#pragma mark 系统分享
+ (void)shareSystem:(NSString *)title
                url:(NSString *)url
        compeletion:(void(^)(NSString *error))completion;
#pragma mark 回调调用
+ (BOOL)handleOpenURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
