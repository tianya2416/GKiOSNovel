//
//  ATAlertView.m
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATAlertView.h"
#import <MMPopupView/MMPopupItem.h>
#import <MMPopupView/MMPopupCategory.h>
#import <MMPopupView/MMPopupDefine.h>
#import <Masonry/Masonry.h>
#import "UITextField+ATKit.h"
#import "YYKit.h"
@implementation ATAlertView

+ (instancetype)showTitle:(NSString *)title message:(NSString *)message normalButtons:(NSArray *)normalButtons highlightButtons:(NSArray *)highlightButtons completion:(ATAlertViewCompletion)completion
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
    
    ATAlertView *alertView = [[self alloc] initWithTitle:title detail:message items:items];
    [alertView show];
    return alertView;
}

@end

@interface ATAlertInputView() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) NSMutableArray<UITextField *> *inputViews;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) NSArray     *actionItems;
@property (nonatomic, strong) UIButton    *confirmButton;

@property (nonatomic, copy) ATAlertInputViewHandler inputHandler;

@end

@implementation ATAlertInputView

+ (instancetype)showWithTitle:(NSString *)title inputConfig:(ATAlertInputViewConfig)inputConfig notifyChange:(ATAlertInputViewTextDidChange)notifyChange handler:(ATAlertInputViewHandler)inputHandler
{
    ATAlertInputView *input = [[self alloc] initWithTitle:title inputConfig:inputConfig notifyChange:notifyChange handler:inputHandler];
    [input show];
    return input;
}

- (instancetype)initWithTitle:(NSString *)title inputConfig:(ATAlertInputViewConfig)inputConfig notifyChange:(ATAlertInputViewTextDidChange)notifyChange handler:(ATAlertInputViewHandler)inputHandler {
    if (self = [super init]) {
        
        MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
        
        self.type = MMPopupTypeAlert;
        self.withKeyboard = (inputHandler!=nil);
        self.inputHandler = inputHandler;
        self.actionItems = @[MMItemMake(@"取消", MMItemTypeNormal, nil),
                             MMItemMake(@"确定", MMItemTypeHighlight, nil)
                             ];
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH * 0.8);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.titleLabel.textColor = config.detailColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        //259B24
        for (NSUInteger index = 0; index <= 5; index++)
        {
            UITextField *inputView = [UITextField new];
            [self addSubview:inputView];
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(index == 0 ? 20 : 10);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                make.height.mas_equalTo(40);
            }];
            inputView.tag = index;
//            inputView.delegate = self;
            inputView.backgroundColor = self.backgroundColor;
            inputView.layer.borderWidth = MM_SPLIT_WIDTH;
            inputView.layer.borderColor = config.splitColor.CGColor;
            inputView.layer.cornerRadius = 2;
            inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            inputView.leftViewMode = UITextFieldViewModeAlways;
            inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.inputViews addObject:inputView];
            @weakify(self)
            [inputView notifyChange:^NSInteger(UITextField *textField, NSString *text) {
                if (notifyChange) {
                    @strongify(self)
                    return notifyChange(index, textField, text, self.confirmButton);
                }
                return -1;
            }];
            
            lastAttribute = inputView.mas_bottom;
            
            if (inputConfig) {
                if (!inputConfig(index, inputView)) {
                    break;
                }
            }
            else {
                break;
            }
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(config.innerMargin);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < self.actionItems.count; ++i )
        {
            MMPopupItem *item = self.actionItems[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if ( self.actionItems.count <= 2 )
                {
                    make.top.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.left.equalTo(self.buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.left.equalTo(lastButton.mas_right).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                }
                else
                {
                    make.left.right.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];

            [btn setTitleColor:item.highlight?config.itemHighlightColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (btn==self.actionItems.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if ( self.actionItems.count <= 2 )
            {
                make.right.equalTo(self.buttonView.mas_right).offset(MM_SPLIT_WIDTH);
            }
            else
            {
                make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
            }
            
        }];
        self.confirmButton = lastButton;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.buttonView.mas_bottom);
            
        }];

    }
    
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled ) {
        return;
    }
    
    if ( self.inputHandler ) {
        NSMutableArray *texts = [NSMutableArray array];
        [self.inputViews enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [texts addObject:obj.text];
        }];
        if (self.inputHandler(btn.tag, texts)) {
            [self hide];
        }
    }
    else {
        [self hide];
    }
}

#pragma mark - actions
- (void)showKeyboard {
    [self.inputViews.firstObject becomeFirstResponder];
}
- (void)hideKeyboard {
    [self endEditing:YES];
}

#pragma mark - getter
- (NSMutableArray<UITextField *> *)inputViews {
    if (!_inputViews) {
        _inputViews = [NSMutableArray array];
    }
    return _inputViews;
}
@end
