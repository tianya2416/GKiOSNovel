//
//  GKSearchView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchTextView.h"

@implementation GKSearchTextView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = AppColor;
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.cornerRadius = AppRadius;
    self.textField.placeholder = @"作者/书名";
    [self.textField notifyChange:^NSInteger(UITextField *textField, NSString *text) {
        return 12;
    }];
    self.textField.tintColor = AppColor;
    
}

@end
