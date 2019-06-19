//
//  GKReadView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadView.h"
@interface GKReadView()
@property (assign, nonatomic) CTFrameRef contentFrame;
@end
@implementation GKReadView
-(void)dealloc {
    if (_contentFrame) {
        CFRelease(_contentFrame);
    }
}
- (void)setContent:(NSAttributedString *)content {
    _content = content;
//    NSLog(@"content : %@",_content);
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)content);
    CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    if (setterRef) {
        CFRelease(setterRef);
    }
    if (pathRef) {
        CFRelease(pathRef);
    }
    self.contentFrame = frameRef;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!_contentFrame) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CTFrameDraw(_contentFrame, ctx);
}

@end
