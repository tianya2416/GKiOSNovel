//
//  GKReadManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GKReadState) {
    GKReadDefault =  0,//默认
    GKReadNight   =  1,//晚上
    GKReadGreen   =  2,//墨绿色
    GKReadCaffee  =  3,//咖啡色
    GKReadPink    =  4,//咖啡色
};
NS_ASSUME_NONNULL_BEGIN
@interface GKReadSetModel : BaseModel

@property (assign, nonatomic) CGFloat font;//文字大小
@property (assign, nonatomic) UIFontWeight weight;//字体类型
@property (strong, nonatomic) UIColor *color;//文字颜色
@property (assign, nonatomic) CGFloat lineSpacing;//段落 行间距
@property (assign, nonatomic) CGFloat firstLineHeadIndent;//段落 行间距
@property (assign, nonatomic) CGFloat paragraphSpacingBefore;//段间距，当前段落和上个段落之间的距离。
@property (assign, nonatomic) CGFloat paragraphSpacing;//段间距，当前段落和下个段落之间的距离。
@property (assign, nonatomic) CGFloat brightness;//亮度

@property (assign, nonatomic) GKReadState state;

@end
@interface GKReadManager : NSObject

@property (strong, nonatomic,readonly)GKReadSetModel *model;

+ (instancetype)shareInstance;
+ (BOOL)saveReadSetModel:(GKReadSetModel *)model;

+ (NSDictionary *)defaultAtt;
+ (UIImage *)defaultBackView;
@end

NS_ASSUME_NONNULL_END
