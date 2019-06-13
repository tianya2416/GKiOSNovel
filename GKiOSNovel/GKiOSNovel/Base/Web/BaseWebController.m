//
//  BaseWebController.m
//  FDLive
//
//  Created by wws1990 on 2017/2/28.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import "BaseWebController.h"

@interface BaseWebController ()

@end

@implementation BaseWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createContentView];
}
#pragma mark - 控件初始化
-(ProgressWKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[ProgressWKWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        [_webView setProgressTintColor:AppColor TrackColor:[UIColor colorWithRGB:0xffeecc]];
    }
    return _webView;
}


#pragma mark - 界面初始化
-(void)createNav
{

//    [self.webView.wkWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)([self class])];
//    //加个右边空白显示的按钮
//    UIButton *right1Btn = [[UIButton alloc] initWithFrame:(CGRect){0,0,40,40}];
//    UIBarButtonItem * right1Item = [[UIBarButtonItem alloc] initWithCustomView:right1Btn];
//    self.navigationItem.rightBarButtonItem = right1Item;
    
}

-(void)createContentView
{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview);
    }];
}

//#pragma mark - 监控
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if([keyPath isEqualToString:@"canGoBack"])
//    {
//        [self showNavTitle:self.title backItem:self.webView.wkWebView.canGoBack];
//    }
//}
//- (void)goBack{
//    if ([self.webView.wkWebView canGoBack])
//    {
//        [self.webView.wkWebView goBack];
//    }
//    else
//    {
//        [super goBack];
//    }
//}
#pragma mark - 外部接口
- (void)loadRequest:(NSURLRequest *)request
{
    [self.webView loadRequest:request];
}

- (void)loadURL:(NSURL *)URL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    if(!URLString.length)
    {
        return;
    }
   [self isNeedGetTicketWithUrlStr:URLString];
}
- (void)loadHTMLString:(NSString *)HTMLString{
    [self loadHTMLString:HTMLString baseURL:nil];
}
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL{
    [self.webView.wkWebView loadHTMLString:HTMLString baseURL:baseURL];
}
- (void)loadFileURL:(NSURL *)loadFileURL allowingReadAccessToURL:(NSURL *)allowingReadAccessToURL{
    [self.webView.wkWebView loadFileURL:loadFileURL allowingReadAccessToURL:allowingReadAccessToURL];
}


//TODO: 判断是否需要登录操作
-(void)isNeedGetTicketWithUrlStr:(NSString *)urlStr
{
    NSURL *URL = [NSURL URLWithString:urlStr];
    [self.webView loadURL:URL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    //[self.webView.wkWebView removeObserver:self forKeyPath:@"canGoBack"];
}
@end
