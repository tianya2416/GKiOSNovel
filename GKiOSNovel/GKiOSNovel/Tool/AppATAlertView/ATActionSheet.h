//
//  ATActionSheet.h
//  AT
//
//  Created by Apple on 14-10-12.
//  Copyright (c) 2014年 Summer. All rights reserved.
//
#import <MMSheetView.h>
#import <MMPopupView/MMSheetView.h>
@class ATActionSheet;

typedef void(^ATActSheetCompletion)(NSInteger index, NSString *buttonTitle);

@interface ATActionSheet : MMSheetView

/**
 *  显示一个选择器 (点击取消并不会出发completion回调, 有特别需求请调用 setHideCompletionBlock 来处理)
 *
 *  @param title            选择器标题
 *  @param normalButtons    选择器常规按钮
 *  @param highlightButtons 选择器高亮按钮
 *  @param completion       完成是回调(index: 按钮编号从0开始, 先常规按钮再高亮按钮 buttonTitle: 按钮标题)
 *
 *  @return 返回选择器实例
 */
+ (instancetype)showWithTitle:(NSString *)title
                normalButtons:(NSArray<NSString *> *)normalButtons
             highlightButtons:(NSArray<NSString *> *)highlightButtons
                   completion:(ATActSheetCompletion)completion;

@end
