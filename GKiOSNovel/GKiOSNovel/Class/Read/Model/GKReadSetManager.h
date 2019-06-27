//
//  GKReadManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GKReadState) {
    GKReadDefault =  0,//白天
    GKReadBlack   =  1,//晚上
    GKReadGreen   =  2,//墨绿色
    GKReadCaffee  =  3,//咖啡色
    GKReadPink    =  4,//淡粉
    GKReadFen     =  5,//粉红色
    GKReadZi      =  6,//紫色
    GKReadYellow  =  7,//黄色
};
NS_ASSUME_NONNULL_BEGIN
@interface GKReadSkinModel : BaseModel
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *skin;
@property (assign, nonatomic) GKReadState state;
@end
@interface GKReadSetModel : BaseModel

@property (assign, nonatomic) UIFontWeight weight;//字体类型
@property (assign, nonatomic) CGFloat font;//文字大小
@property (strong, nonatomic) UIColor *color;//文字颜色
@property (assign, nonatomic) CGFloat lineSpacing;//段落 行间距
@property (assign, nonatomic) CGFloat firstLineHeadIndent;//段落 行间距
@property (assign, nonatomic) CGFloat paragraphSpacingBefore;//段间距，当前段落和上个段落之间的距离。
@property (assign, nonatomic) CGFloat paragraphSpacing;//段间距，当前段落和下个段落之间的距离。
@property (assign, nonatomic) CGFloat brightness;//亮度

@property (assign, nonatomic) GKReadState state;

@end
@interface GKReadSetManager : NSObject
@property (strong, nonatomic,readonly)GKReadSetModel *model;
+ (instancetype)shareInstance;

+ (void)setReadState:(GKReadState)state;//切换皮肤
+ (void)setBrightness:(CGFloat)brightness;//切换亮度
+ (void)setFont:(CGFloat )font;//设置字体大小


+ (NSDictionary *)defaultFont;
+ (UIImage *)defaultSkin;
+ (NSArray *)defaultSkinDatas;
@end

NS_ASSUME_NONNULL_END
