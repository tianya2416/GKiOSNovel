//
//  GKReadSetModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/26.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadSetModel.h"

@implementation GKReadSetModel
- (NSString *)color{
    return _color ?: @"999999";
}
- (NSString *)fontName{
    return _fontName ?: [BaseMacro fontName];
}
- (CGFloat)font{
    return _font ?: 20;
}
- (CGFloat)lineSpacing{
    return _lineSpacing ?: 10;
}
- (CGFloat)firstLineHeadIndent{
    return _firstLineHeadIndent ?: 30;
}
- (CGFloat)paragraphSpacingBefore{
    return _paragraphSpacingBefore ?: 10;
}
- (CGFloat)paragraphSpacing{
    return _paragraphSpacing ?: 10;
}
- (GKReadThemeState)state{
    return _state ?: GKReadDefault;
}
- (GKBrowseState )browseState{
    return _browseState ?: GKBrowseDefault;
}
- (CGFloat)brightness{
    return [[UIScreen mainScreen] brightness];
}
@end


@implementation GKReadSkinModel
+ (instancetype)vcWithTitle:(NSString *)title skin:(NSString *)skin state:(GKReadThemeState)state{
    GKReadSkinModel *vc = [[[self class] alloc] init];
    vc.title = title;
    vc.skin = skin;
    vc.state = state;
    return vc;
}
@end
