//
//  GKSearchTopView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/9/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKSearchTopView.h"
@interface GKSearchTopView()<UITextFieldDelegate>
@property (assign, nonatomic) BOOL canTap;
@end
@implementation GKSearchTopView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = AppRadius * 2;
    self.searchBtn.layer.masksToBounds = YES;
    self.searchBtn.layer.cornerRadius = AppRadius * 2;
    self.searchText.tintColor = Appx333333;
    self.searchText.textColor = Appx333333;
    
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateSelected];
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:Appx999999] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:Appx999999] forState:UIControlStateNormal|UIControlStateHighlighted];
    self.searchBtn.selected = NO;
    [self.searchText addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
    self.searchText.delegate = self;
}
- (void)textAction:(UITextField *)sender{
    self.canTap = sender.text.length > 0;
}
- (void)setKeyword:(NSString *)keyword{
    if (![_keyword isEqualToString:keyword]) {
        _keyword = keyword;
        self.searchText.text = keyword;
        [self textAction:self.searchText];
    }
}
- (void)setCanTap:(BOOL)canTap{
    if (_canTap != canTap) {
        _canTap = canTap;
        self.searchBtn.selected = _canTap;
        self.searchBtn.userInteractionEnabled = _canTap;
    }
}
- (IBAction)searchAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchTopView:keyword:)]) {
        [self.delegate searchTopView:self keyword:self.searchText.text];
    }
}
- (IBAction)backAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchTopView:goback:)]) {
        [self.delegate searchTopView:self goback:YES];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
        return NO;
    }
    [self searchAction:self.searchBtn];
    return YES;
}
@end
