//
//  GKReadManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKReadSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKReadSetManager : NSObject

@property (strong, nonatomic,readonly)GKReadSetModel *model;

+ (instancetype)shareInstance;
+ (void)setLandscape:(BOOL)landscape;//横屏
+ (void)setTraditiona:(BOOL)traditiona;//设置繁体
+ (void)setBrightness:(CGFloat)brightness;//切换亮度
+ (void)setFontName:(NSString *)fontName;//设置字体名称
+ (void)setFont:(CGFloat)font;//设置字体大小
+ (void)setReadState:(GKReadThemeState)state;//切换皮肤
+ (void)setBrowseState:(GKBrowseState)browseState;//阅读方式

+ (NSDictionary *)defaultFont;
+ (UIImage *)defaultSkin;
+ (NSArray *)defaultSkinDatas;
+ (NSString *)convertToTraditional:(NSString *)simpString;

@end

NS_ASSUME_NONNULL_END
