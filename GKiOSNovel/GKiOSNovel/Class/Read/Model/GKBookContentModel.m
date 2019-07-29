//
//  GKBookContentModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookContentModel.h"

@interface GKBookContentModel()
@property (strong, nonatomic) NSMutableArray *pageArray;
@property (strong, nonatomic) NSAttributedString *attributedString;
@end

@implementation GKBookContentModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"contentId":@[@"contentId",@"id"],@"content":@[@"cpContent",@"body",@"content"]};
}
- (void)setContent:(NSString *)content{
    _content = content;
    _content = [_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _content = [_content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
}
- (void)setContentPage {
    [self setPageBound:[BaseMacro appFrame]];
}
- (void)setPageBound:(CGRect)bounds {
    self.pageArray = @[].mutableCopy;
    NSAttributedString *attr = [[NSAttributedString  alloc] initWithString:self.content attributes:[GKReadSetManager defaultFont]];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attr);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    CFRange range = CFRangeMake(0, 0);
    NSUInteger rangeOffset = 0;
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, NULL);
        range = CTFrameGetVisibleStringRange(frame);
        rangeOffset += range.length;
        [self.pageArray addObject:@(range.location)];
        if (frame) {
            CFRelease(frame);
        }
    } while (range.location + range.length < attr.length);
    if (path) {
        CFRelease(path);
    }
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    self.attributedString = attr;
}
- (NSInteger)pageCount{
    return self.pageArray.count;
}
- (NSAttributedString *)getContentAtt:(NSInteger)page {
    page = (page >= self.pageArray.count) ? self.pageArray.count - 1 : page;
    if (page < self.pageArray.count) {
        NSUInteger loc = [self.pageArray[page] integerValue];
        NSUInteger len = 0;
        if (page == self.pageArray.count - 1) {
            len = self.attributedString.length - loc;
        } else {
            len = [self.pageArray[page + 1] integerValue] - loc;
        }
        NSAttributedString *att = [_attributedString attributedSubstringFromRange:NSMakeRange(loc, len)];
        GKReadSetModel *model = [GKReadSetManager shareInstance].model;
        return model.traditiona ? [[NSAttributedString alloc] initWithString:[GKReadSetManager convertToTraditional:att.string] attributes:att.attributes] : att;
    }
    return [[NSAttributedString alloc] initWithString:@"更多精彩内容尽在追书申请\n\r\n\r数据加载中...\n\r\n\r请耐心等待" attributes:[GKReadSetManager defaultFont]];
}
- (NSArray *)positionDatas{
    return self.pageArray;
}
- (NSInteger)getChangeIndex:(NSNumber *)position{
    
    if (position.integerValue <= 0) {
        return 0;
    }
    __block NSInteger index = 0;
    [self.pageArray enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue >= position.integerValue - 30) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
@end

