//
//  GKLaunchController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/2.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKLaunchController.h"
#import "GKLaunchView.h"
#import <Lottie/Lottie.h>

@interface GKLaunchController ()
@property (strong, nonatomic) GKLaunchView *launchView;
@property (strong, nonatomic) LOTAnimationView *playView;
@property (strong, nonatomic) UIButton *skipBtn;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation GKLaunchController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.launchView];
    [self.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.launchView.superview).offset(0);
        make.bottom.equalTo(self.launchView.superview).offset(-TAB_BAR_ADDING);
        make.height.offset(150);
    }];
    [self.view addSubview:self.skipBtn];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.top.equalTo(self.skipBtn.superview).offset(STATUS_BAR_HIGHT);
        make.left.equalTo(self.skipBtn.superview).offset(20);
    }];
    [self.skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [self startTimer];
    
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playView.superview);
        make.width.height.offset(SCALEW(250));
    }];
    NSLog(@"=====");
    @weakify(self)
    [self.playView playFromProgress:0.0 toProgress:1.0 withCompletion:^(BOOL animationFinished) {
        @strongify(self)
        if (animationFinished) {
            self.playView.alpha = 1.0f;
            [UIView animateWithDuration:0.25 animations:^{
                self.playView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.playView removeFromSuperview];
                }
            }];
        }
    }];
}
- (void)skipAction{
    [self stopTimer];
    [self dismissController];
}

- (void)startTimer{
    self.skipBtn.hidden = NO;
    __block NSInteger time = 5 - 1;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"%@S",@(time)] forState:UIControlStateNormal];
    @weakify(self)
    self.timer = [NSTimer timerWithTimeInterval:1.0f block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        if (time <=0) {
            [self skipAction];
        }
        time = time - 1;
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@S",@(time < 0 ? 0 : time)] forState:UIControlStateNormal];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}
- (void)dismissController
{
    [UIView animateWithDuration:0.35 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
         [self goBack:NO];
    }];
}
- (GKLaunchView *)launchView{
    if (!_launchView) {
        _launchView = [GKLaunchView instanceView];
    }
    return _launchView;
}
- (UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.backgroundColor = Appx999999;
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = 22;
    }
    return _skipBtn;
}
- (LOTAnimationView *)playView{
    if (!_playView) {
        //        NSString *url = [[NSBundle mainBundle] pathForResource:@"servishero_loading" ofType:@"json"];
        _playView = [LOTAnimationView animationNamed:@"Launch.json"];
        _playView.loopAnimation = NO;
        _playView.animationSpeed = 1.0f;
    }
    return _playView;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
