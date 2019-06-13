//
//  ProgressWKWebView.h
//  FDLive
//
//  Created by wws1990 on 2017/2/28.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class ProgressWKWebView;
@protocol ProgressWKDelegate <NSObject>

@optional
- (void)fdwebView:(ProgressWKWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)fdwebView:(ProgressWKWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)fdwebView:(ProgressWKWebView *)webview shouldStartLoadWithURL:(NSURL *)URL decisionHandler:(void (^)(BOOL cancelTurn))decisionHandler;
- (void)fdwebViewDidStartLoad:(ProgressWKWebView *)webview;
- (void)fdwebViewChangeTitle:(ProgressWKWebView *)webview;
@end

/**
 *  带加载进度条的wkWeb
 */
@interface ProgressWKWebView : UIView
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, weak) id <ProgressWKDelegate> delegate;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadURL:(NSURL *)URL;
- (void)loadURLString:(NSString *)URLString;
- (void)loadHTMLString:(NSString *)HTMLString;
- (void)setProgressTintColor:(UIColor *)tintColor TrackColor:(UIColor *)trackColor;
@end
