//
//  ATSheetView.h
//  AT
//
//  Created by CoderLT on 15/11/17.
//  Copyright © 2015年 AT. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>

@interface ATSheetView : MMPopupView

@property (nonatomic, strong, readonly) UIButton *btnCancel;
@property (nonatomic, strong, readonly) UIButton *btnConfirm;
@property (nonatomic, strong, readonly) UIView *contentView;
/**
 *  设置完成时回调
 *
 *  @param completion 完成是回调(sheet: 实例, confirm: 是否点击了确认按钮)
 */
- (void)setDismissCompletion:(void(^)(ATSheetView *sheet, BOOL confirm))completion;
@end
