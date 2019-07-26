//
//  GKAppModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKAppModel.h"
static NSString *gkTheme = @"gkTheme";
@implementation GKAppModel

@end

@interface GKAppTheme ()
@property (strong, nonatomic) GKAppModel *model;
@property (assign, nonatomic) GKThemeState themeState;
@end
@implementation GKAppTheme
+ (instancetype )shareInstance
{
    static GKAppTheme * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}

+ (GKAppModel *)defaultTheme:(GKThemeState)themeState{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"App" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *title = @"too_blue";
    switch (themeState) {
        case GKThemeDefault:
            title = @"too_blue";
            break;
        case GKThemeTooHouse:
            title = @"too_house";
            break;
        case GKThemeTooGold:
            title = @"too_gold";
            break;
        case GKThemeTooZi:
            title = @"too_zi";
            break;
        case GKThemeTooFen:
            title = @"too_fen";
            break;
        default:
            break;
    }
    GKAppModel *_model = [GKAppModel modelWithJSON:dic[title]];
    if (!_model) {
        _model = [[GKAppModel alloc] init];
        _model.color = @"66A2F9";
        _model.icon_mine_h = @"icon_mine_h";
        _model.icon_mine_n = @"icon_mine_n";
        _model.icon_case_h = @"icon_case_h";
        _model.icon_case_n = @"icon_case_n";
        _model.icon_home_h = @"icon_home_h";
        _model.icon_home_n = @"icon_home_n";
        _model.icon_class_h = @"icon_class_h";
        _model.icon_class_n = @"icon_class_n";
        _model.icon_more = @"icon_more";
        _model.icon_man = @"icon_man";
    }
    [GKAppTheme saveAppTheme:_model];
    return _model;
}
+ (BOOL)saveAppTheme:(GKAppModel *)appModel
{
    [GKAppTheme shareInstance].model = appModel;
    BOOL res = NO;
    NSData *userData = [BaseModel archivedDataForData:appModel];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:gkTheme];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
- (GKAppModel *)model{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkTheme];
    _model = data ? [BaseModel unarchiveForData:data]: [GKAppTheme defaultTheme:GKThemeDefault];
    return _model;
}
@end
