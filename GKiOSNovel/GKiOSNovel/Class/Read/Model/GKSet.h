//
//  GKSet.h
//  GKSeekSth
//
//  Created by wangws1990 on 2019/7/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, GKSkinState) {
    GKReadDefault =  0,//白天
    GKReadGreen   =  1,//墨绿色
    GKReadCaffee  =  2,//咖啡色
    GKReadPink    =  3,//淡粉
    GKReadFen     =  4,//粉红色
    GKReadZi      =  5,//紫色
    GKReadYellow  =  6,//黄色
};
typedef NS_ENUM(NSInteger, GKBrowseState) {
    GKBrowseDefault    = 0,//默认
    GKBrowsePageCurl   = 1,//仿真
    GKBrowseVertical   = 2,//无动画
};
NS_ASSUME_NONNULL_BEGIN

@interface GKSet : BaseModel

@property (copy, nonatomic) NSString *color;//文字颜色
@property (copy, nonatomic) NSString *fontName;//字体名称
@property (assign, nonatomic) CGFloat font;//文字大小
@property (assign, nonatomic) CGFloat lineSpacing;//段落 行间距
@property (assign, nonatomic) CGFloat firstLineHeadIndent;//每段 段首空格
@property (assign, nonatomic) CGFloat paragraphSpacingBefore;//段间距，当前段落和上个段落之间的距离。
@property (assign, nonatomic) CGFloat paragraphSpacing;//段间距，当前段落和下个段落之间的距离。
@property (assign, nonatomic) CGFloat brightness;//亮度
@property (assign, nonatomic) BOOL night;//是否是晚上
@property (assign, nonatomic) BOOL landscape;//是否是横屏
@property (assign, nonatomic) BOOL traditiona;//繁体
@property (assign, nonatomic) GKSkinState state;//皮肤控制
@property (assign, nonatomic) GKBrowseState browseState;//阅读方式

@end

@interface GKSkin : BaseModel
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *skin;
@property (assign, nonatomic) GKSkinState state;
+ (instancetype)vcWithTitle:(NSString *)title skin:(NSString *)skin state:(GKSkinState)state;
@end
NS_ASSUME_NONNULL_END
