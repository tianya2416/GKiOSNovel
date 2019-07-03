//
//  ATAlertView.h
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <MMPopupView/MMAlertView.h>

typedef void(^ATAlertViewCompletion)(NSUInteger index, NSString *buttonTitle);
typedef BOOL(^ATAlertInputViewConfig)(NSUInteger index, UITextField *textField);
typedef BOOL(^ATAlertInputViewHandler)(NSUInteger index, NSArray<NSString *> *texts);
typedef NSUInteger(^ATAlertInputViewTextDidChange)(NSUInteger index, UITextField *textField, NSString *text, UIButton *confirmButton);

@interface ATAlertView : MMAlertView
/**
 *  弹出提示
 *
 *  @param title            标题
 *  @param message          详情
 *  @param normalButtons    常规按钮标题数组
 *  @param highlightButtons 高亮按钮标题数组
 *  @param completion       完成时回调(index: 按钮编号, buttonTitle: 按钮标题)
 *
 *  @return 返回弹出实例
 */
+ (instancetype)showTitle:(NSString *)title
                  message:(NSString *)message
            normalButtons:(NSArray<NSString *> *)normalButtons
         highlightButtons:(NSArray<NSString *> *)highlightButtons
               completion:(ATAlertViewCompletion)completion;
@end

@interface ATAlertInputView : MMPopupView

/**
 *  显示一个带输入框的弹窗
 *
 *  @param title                 标题
 *  @param inputConfig           输入框样式设置(UIKeyboardType\placeholder等), 输入框的个数返回BOOL参数决定, YES则继续配置下一个输入框
 *  @param notifyChange          输入框值改变时回调函数(NSIntger: 返回允许字符长度, 负数为不限制, index: 输入框编号, textField: 输入框, text: 输入框文本, confirm: 确定按钮)
 *  @param inputHandler          按钮点击回调(BOOL: 是否允许消失, index: 被点击的按钮编号 texts: 输入框文本数组)
 *
 *  @return 弹窗实例
 */
+ (instancetype)showWithTitle:(NSString *)title
                  inputConfig:(ATAlertInputViewConfig)inputConfig
                 notifyChange:(ATAlertInputViewTextDidChange)notifyChange
                      handler:(ATAlertInputViewHandler)inputHandler;
@end
