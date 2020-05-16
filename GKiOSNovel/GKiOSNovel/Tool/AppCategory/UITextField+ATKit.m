//
//  UITextField+ATKit.m
//  Postre
//
//  Created by 王炜圣 on 2017/4/6.
//  Copyright © 2017年 王炜圣. All rights reserved.
//

#import "UITextField+ATKit.h"
#import <objc/runtime.h>
@interface _NSNotificationWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, weak) id<NSObject> note;
@end
@implementation _NSNotificationWeakTarget
- (instancetype)initWithTarget:(id)target
                          name:(NSString *)name
                         block:(void(^)(NSNotification * _Nonnull note))block {
    if (self = [super init]) {
        _target = target;
        _note = [[NSNotificationCenter defaultCenter] addObserverForName:name object:target queue:nil usingBlock:block];
    }
    return self;
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:_note];
    } @catch (NSException *exception) {
    }
}
@end

NSRange textInputTrimByLength(UIView<UITextInput> *input, NSInteger maxLength) {
    if (maxLength < 0) {
        return NSMakeRange(0, 0);
    }
    NSString *text = [input textInRange:[input textRangeFromPosition:input.beginningOfDocument toPosition:input.endOfDocument]];
    if (maxLength < text.length) {
        NSInteger offset = [input offsetFromPosition:input.beginningOfDocument toPosition:input.selectedTextRange.end];
        NSInteger del = text.length - maxLength;
        NSInteger start = offset > del ? offset - del : 0;
        NSRange range = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(start, del)];
        UITextRange *textRange = [input textRangeFromPosition:[input positionFromPosition:input.beginningOfDocument offset:range.location] toPosition:[input positionFromPosition:input.beginningOfDocument offset:NSMaxRange(range)]];
        [input replaceRange:textRange withText:@""];
        return range;
    }
    return NSMakeRange(0, 0);
}

static const char targetKey = '\0';
@implementation UITextField (ATKit)
- (void)notifyChange:(NSInteger (^)(UITextField *, NSString *))block {
    _NSNotificationWeakTarget *target;
    if (block) {
        __weak typeof(self)weakSelf = self;
        target = [[_NSNotificationWeakTarget alloc] initWithTarget:weakSelf name:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull note) {
            if (!weakSelf.markedTextRange) {
                NSInteger maxLength = block(weakSelf, weakSelf.text);
                textInputTrimByLength(weakSelf, maxLength);
            }
        }];
    }
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation UITextView (ATKit)
- (void)notifyChange:(NSInteger (^)(UITextView *, NSString *))block {
    _NSNotificationWeakTarget *target;
    if (block) {
        __weak typeof(self)weakSelf = self;
        target = [[_NSNotificationWeakTarget alloc] initWithTarget:weakSelf name:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull note) {
            if (!weakSelf.markedTextRange) {
                NSInteger maxLength = block(weakSelf, weakSelf.text);
                textInputTrimByLength(weakSelf, maxLength);
            }
        }];
    }
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_RETAIN);
}
@end
