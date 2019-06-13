//
//  BaseWebController.h
//  FDLive
//
//  Created by wws1990 on 2017/2/28.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import "BaseViewController.h"
#import "ProgressWKWebView.h"

/**
 *  网页
 */
@interface BaseWebController : BaseViewController<ProgressWKDelegate>
@property (nonatomic,strong)ProgressWKWebView *webView;
- (void)loadURLString:(NSString *)URLString;
- (void)loadHTMLString:(NSString *)HTMLString;
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;
- (void)loadFileURL:(NSURL *)loadFileURL allowingReadAccessToURL:(NSURL *)allowingReadAccessToURL;
@end
