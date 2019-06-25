//
//  GKAppModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GKThemeState) {
    GKThemeDefault  = 0,
    GKThemeTooHouse = 1,
    GKThemeTooGold  = 2,
};
@interface GKAppModel : BaseModel
@property (copy, nonatomic) NSString *color;

@property (copy, nonatomic) NSString *icon_case_h;
@property (copy, nonatomic) NSString *icon_case_n;
@property (copy, nonatomic) NSString *icon_class_h;
@property (copy, nonatomic) NSString *icon_class_n;
@property (copy, nonatomic) NSString *icon_home_h;
@property (copy, nonatomic) NSString *icon_home_n;
@property (copy, nonatomic) NSString *icon_mine_h;
@property (copy, nonatomic) NSString *icon_mine_n;

@property (copy, nonatomic) NSString *icon_more;
@end

@interface GKAppTheme :NSObject
@property (strong, nonatomic,readonly) GKAppModel *model;
@property (assign, nonatomic) GKThemeState themeState;
+ (instancetype )shareInstance;
@end

NS_ASSUME_NONNULL_END
