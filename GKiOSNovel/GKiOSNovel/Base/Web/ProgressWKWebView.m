//
//  ProgressWKWebView.m
//  FDLive
//
//  Created by wws1990 on 2017/2/28.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import "ProgressWKWebView.h"



static void *FDWebBrowserContext = &FDWebBrowserContext;


@interface ProgressWKWebView ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ProgressWKWebView
- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createContentView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createContentView];
    }
    return self;
}


- (void)dealloc {
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];

}


#pragma mark - 控件数据初始化
-(WKWebView *)wkWebView
{
    if (!_wkWebView) {
//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //config.userContentController = wkUController;
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
//        preference.minimumFontSize = 16;
        // 设置偏好设置对象
        config.preferences = preference;

        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];;
        [_wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_wkWebView setNavigationDelegate:self];
        [_wkWebView setUIDelegate:self];
        [_wkWebView setMultipleTouchEnabled:YES];
        [_wkWebView setAutoresizesSubviews:YES];
        [_wkWebView.scrollView setAlwaysBounceVertical:YES];
        _wkWebView.scrollView.bounces = YES;
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:FDWebBrowserContext];
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _wkWebView;
}

-(UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.backgroundColor = [UIColor clearColor];
        [_progressView setTrackTintColor:[UIColor greenColor]];
        [_progressView setTintColor:[UIColor redColor]];
    }
    return _progressView;
}

#pragma mark - 界面生成
-(void)createContentView
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.wkWebView.superview);
    }];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.progressView.superview);
        make.height.equalTo(@(2.0f));
        make.top.equalTo(self.progressView.superview).offset(0);
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if([self.delegate respondsToSelector:@selector(fdwebViewDidStartLoad:)])
    {
        [self.delegate fdwebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    if([self.delegate respondsToSelector:@selector(fdwebView:didFinishLoadingURL:)])
    {
        [self.delegate fdwebView:self didFinishLoadingURL:self.wkWebView.URL];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(fdwebView:didFailToLoadURL:error:)])
    {
        [self.delegate fdwebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(fdwebView:didFailToLoadURL:error:)])
    {
        [self.delegate fdwebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if([self.delegate respondsToSelector:@selector(fdwebView:shouldStartLoadWithURL:decisionHandler:)])
    {
        [self.delegate fdwebView:self shouldStartLoadWithURL:navigationAction.request.URL decisionHandler:^(BOOL cancelTurn) {
            decisionHandler(cancelTurn?WKNavigationActionPolicyCancel:WKNavigationActionPolicyAllow);
        }];
    }
    else
    {
        NSURL *URL = navigationAction.request.URL;
        if(!navigationAction.targetFrame)
        {
            [self loadURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView)
    {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        @weakify(self)
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                @strongify(self)
                [self.progressView setAlpha:0.0f];
            }
                             completion:^(BOOL finished)
            {
                @strongify(self)
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.wkWebView)
    {
        if ([self.delegate respondsToSelector:@selector(fdwebViewChangeTitle:)]) {
            [self.delegate fdwebViewChangeTitle:self];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 外部接口
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}

- (void)setProgressTintColor:(UIColor *)tintColor TrackColor:(UIColor *)trackColor
{
    [self.progressView setTrackTintColor:trackColor];
    [self.progressView setTintColor:tintColor];
}

@end
