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
    return _font ?: 20;
}
- (CGFloat)lineSpacing{
    return 10;
}
- (CGFloat)firstLineHeadIndent{
    return 25;
}
- (CGFloat)paragraphSpacingBefore{
    return 10;
}
- (CGFloat)paragraphSpacing{
    return 10;
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
