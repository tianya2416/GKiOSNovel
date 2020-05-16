//
//  UITextField+ATKit.h
//  Postre
//
//  Created by 王炜圣 on 2017/4/6.
//  Copyright © 2017年 王炜圣. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSRange textInputTrimByLength(UIView<UITextInput> *input, NSInteger maxLength);

@interface UITextField (ATKit)
/**
 用户输入时回调block

 @param block 返回允许最大Text长度, 负数表示不限制
 */
- (void)notifyChange:(NSInteger(^)(UITextField *textField, NSString *text))block;
@end

@interface UITextView (ATKit)
- (void)notifyChange:(NSInteger(^)(UITextView *textField, NSString *text))block;
@end
