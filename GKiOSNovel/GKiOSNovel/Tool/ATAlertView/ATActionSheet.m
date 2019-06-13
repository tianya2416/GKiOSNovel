//
//  ATActionSheet.m
//  AT
//
//  Created by Apple on 14-10-12.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATActionSheet.h"

@interface ATActionSheet ()
@end

@implementation ATActionSheet

#if defined(APP_COLOR)
+ (void)load {
    MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
    config.itemHighlightColor = APP_COLOR;
    config.defaultTextCancel = ATLocalizedString(@"Cancel", @"取消");
    config.titleColor = [UIColor colorWithHexString:@"#333333"];
    config.buttonHeight = 44;
    config.buttonFontSize = 14;
    config.itemHighlightColor = AppColor
}
#endif

+ (instancetype)showWithTitle:(NSString *)title normalButtons:(NSArray<NSString *> *)normalButtons highlightButtons:(NSArray<NSString *> *)highlightButtons completion:(ATActSheetCompletion)completion
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *btnTitle in normalButtons) {
        [items addObject:MMItemMake(btnTitle, MMItemTypeNormal, ^(NSInteger index){
            if (completion) {
                completion(index, btnTitle);
            }
        })];
    }
    for (NSString *btnTitle in highlightButtons) {
        [items addObject:MMItemMake(btnTitle, MMItemTypeHighlight, ^(NSInteger index){
            if (completion) {
                completion(index, btnTitle);
            }
        })];
    }
    
    ATActionSheet *sheetView = [[self alloc] initWithTitle:title items:items];
    [sheetView show];
    return sheetView;
}
@end
