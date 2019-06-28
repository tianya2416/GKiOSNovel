//
//  GKShareTool.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKShareTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
@interface GKShareTool()<WXApiDelegate,QQApiInterfaceDelegate,TencentSessionDelegate>
@property (copy, nonatomic) void (^completion)(NSString *error);
@end
@implementation GKShareTool
static GKShareTool *_instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (BOOL)isWechatInstalled {
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}

+ (BOOL)isWeiboInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}
+ (void)shareInit {
    [WXApi registerApp:WChatAppKey];
    TencentOAuth * a = [[TencentOAuth alloc] initWithAppId:QQAppKey
                                               andDelegate:[GKShareTool sharedInstance]];
    NSLog(@"%@",a.accessToken);
}
#pragma mark - 回调处理
+ (BOOL)handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:[GKShareTool sharedInstance]];
    [QQApiInterface handleOpenURL:url delegate:[GKShareTool sharedInstance]];
    [TencentOAuth HandleOpenURL:url];
    return NO;
}
#pragma mark - QQ/微信 WXApiDelegate/ApiInterfaceDelegate
- (void)tencentDidLogin {}
- (void)tencentDidNotLogin:(BOOL)cancelled {}
- (void)tencentDidNotNetWork {}
- (void)onReq:(QQBaseReq *)req { }
- (void)isOnlineResponse:(NSDictionary *)response { }
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp * resps = (SendMessageToQQResp *)resp;
        if (resps.result.integerValue == 0) {
            !self.completion ?: self.completion(@"分享成功");
        }
        else if(resps.result.integerValue == -4) {
            !self.completion ?: self.completion(@"分享取消");
        }else
        {
            !self.completion ?: self.completion(@"分享失败");
        }
    }
    else {
        // 微信分享回调
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if (resp.errCode == WXSuccess) {
                !self.completion ?: self.completion(@"分享成功");
            }
            else if (resp.errCode == WXErrCodeUserCancel) {
                !self.completion ?: self.completion(@"分享取消");
            }else
            {
                !self.completion ?: self.completion(@"分享失败");
            }
        }
    }
    self.completion = nil;
}
+ (void)shareTo:(GKShareType)type
       imageUrl:(NSString *)imageUrl
          title:(NSString *)title
       subTitle:(NSString *)subTitle
     completion:(void(^)(NSString *error))completion
{
    NSString *content = [NSString stringWithFormat:@"我正在看<%@>是朋友就一起看吧!\n\r%@",title,subTitle];
    [GKShareTool sharedInstance].completion = completion;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *logo = [UIImage imageNamed:@"icon_logo"];
    NSData *data = UIImageJPEGRepresentation(logo, 0.9f);
    // 图片大小不能超过32k
    if (data.length >= 32 * 1024) {
        data = UIImageJPEGRepresentation([logo imageByResizeToSize:CGSizeMake(120, 120) contentMode:UIViewContentModeScaleAspectFill], 0.9f);
    }
    switch (type) {
        case GKShareTypeWechat:
        case GKShareTypeWechatLine: {
            if (![GKShareTool isWechatInstalled]) {
                !completion ?: completion(@"该设备未安装微信app");
                return;
            }
            //1.创建多媒体消息结构体
            WXMediaMessage *mediaMsg = [WXMediaMessage message];
            mediaMsg.title = title;
            mediaMsg.description = subTitle;
            [mediaMsg setThumbData:data];
            //2.创建多媒体消息中包含的图片数据对象
            WXImageObject *imgObj = [WXImageObject object];
            //图片真实数据
            imgObj.imageData = imageData;
            //多媒体数据对象
            mediaMsg.mediaObject = imgObj;
            //3.创建发送消息至微信终端程序的消息结构体
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            //多媒体消息的内容
//            req.message = mediaMsg;
            req.text = content;
            //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
            req.bText = YES;
            //指定发送到会话(聊天界面)
            req.scene = type == GKShareTypeWechat ? WXSceneSession : WXSceneTimeline;;
            //发送请求到微信,等待微信返回onResp
            [WXApi sendReq:req];
        }break;
        case GKShareTypeQQ:
        case GKShareTypeQQZone: {
            if (![GKShareTool isQQInstalled]) {
                !completion ?: completion(@"该设备未安装QQ");
                return;
            }
            if (type == GKShareTypeQQZone) {
                QQApiImageArrayForQZoneObject * object = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[imageData] title:content extMap:nil];
                SendMessageToQQReq *reqs = [SendMessageToQQReq reqWithContent:object];
                [QQApiInterface SendReqToQZone:reqs];
            }
            else {
               // QQApiImageObject *req = [QQApiImageObject objectWithData:imageData previewImageData:imageData title:content description:nil];
                QQApiTextObject *req = [QQApiTextObject objectWithText:content];
                req.shareDestType = ShareDestTypeQQ;
                SendMessageToQQReq *reqs = [SendMessageToQQReq reqWithContent:req];
                [QQApiInterface sendReq:reqs];
            }
        }break;
        default:
            break;
    }
}
+ (void)shareType:(GKShareType)type url:(NSString *)url title:(NSString *)title subTitle:(NSString *)subTitle compeletion:(void (^)(NSString * _Nonnull))completion{
    [GKShareTool sharedInstance].completion = completion;
    // 图片
    UIImage *image = [UIImage imageNamed:@"icon_logo"];
    NSData *data = UIImageJPEGRepresentation(image, 0.9f);
    // 图片大小不能超过32k
    if (data.length >= 32 * 1024) {
        data = UIImageJPEGRepresentation([image imageByResizeToSize:CGSizeMake(120, 120) contentMode:UIViewContentModeScaleAspectFill], 0.9f);
    }
    switch (type) {
            
        case GKShareTypeWechat:
        case GKShareTypeWechatLine: {
            if (![GKShareTool isWechatInstalled]) {
                !completion ?: completion(@"该设备未安装微信app");
                return;
            }
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description = subTitle;
            message.thumbData = data;
            
            WXWebpageObject *web = [WXWebpageObject object];
            web.webpageUrl = url;
            message.mediaObject = web;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = type == GKShareTypeWechat ? WXSceneSession : WXSceneTimeline;
            [WXApi sendReq:req];
            
            break;
        }
        case GKShareTypeQQ:
        case GKShareTypeQQZone: {
            if (![GKShareTool isQQInstalled]) {
                !completion ?: completion(@"该设备未安装QQ");
                return;
            }
            QQApiURLObject *req = [QQApiURLObject objectWithURL:[NSURL URLWithString:url]
                                                          title:title
                                                    description:subTitle
                                               previewImageData:data
                                              targetContentType:QQApiURLTargetTypeVideo];
            req.shareDestType = ShareDestTypeQQ;
            SendMessageToQQReq *reqs = [SendMessageToQQReq reqWithContent:req];
            if (type == GKShareTypeQQZone) {
                [QQApiInterface SendReqToQZone:reqs];
            }
            else {
                [QQApiInterface sendReq:reqs];
            }
            break;
        }
        default:
            break;
    }
}
+ (void)shareSystem:(NSString *)title
                url:(NSString *)url
        compeletion:(void(^)(NSString *error))completion{
    NSString *content = [NSString stringWithFormat:@"我正在看<%@>是朋友就一起看吧!",title];
    NSArray *activityItems = @[content,[UIImage imageNamed:@"icon_logo"],[NSURL URLWithString:url]];
    UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [vc setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        !completion ?: completion(completed ? @"操作成功":@"操作失败q,请重试");
    }];
    UIViewController *rootVC = [UIViewController rootTopPresentedController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}
@end
