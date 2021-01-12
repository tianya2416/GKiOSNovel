//
//  GKSet.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/7/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSet.h"

@implementation GKSet
- (NSString *)color{
    return @"333333";
}
- (NSString *)fontName{
    return [BaseMacro fontName];
}
- (CGFloat)font{
    return _font ?: 18;
}
- (CGFloat)lineSpacing{
    return _lineSpacing ?: 2;
}
- (CGFloat)firstLineHeadIndent{
    return _firstLineHeadIndent ?: 20;
}
- (CGFloat)paragraphSpacingBefore{
    return _paragraphSpacingBefore ?: 3.5;
}
- (CGFloat)paragraphSpacing{
    return _paragraphSpacing ?: 3.5;
}
- (GKSkinState)state{
    return _state ?: GKReadDefault;
}
- (GKBrowseState )browseState{
    return _browseState ?: GKBrowseDefault;
}
- (CGFloat)brightness{
    return [[UIScreen mainScreen] brightness];
}
@end


@implementation GKSkin

+ (instancetype)vcWithTitle:(NSString *)title skin:(NSString *)skin state:(GKSkinState)state{
    GKSkin *vc = [[[self class] alloc] init];
    vc.title = title;
    vc.skin = skin;
    vc.state = state;
    return vc;
}
@end
