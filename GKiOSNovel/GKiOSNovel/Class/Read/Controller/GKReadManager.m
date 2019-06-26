//
//  GKReadManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadManager.h"
static NSString *gkReadModel = @"gkReadModel";
@implementation GKReadSetModel

@end
@interface GKReadManager()
@property (strong, nonatomic)GKReadSetModel *model;
@end
@implementation GKReadManager
- (instancetype)init{
    if (self = [super init]) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkReadModel];
        _model = data ? [BaseModel unarchiveForData:data]: nil;
    }
    return self;
}
+ (instancetype )shareInstance
{
    static GKReadManager * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
+ (NSDictionary *)defaultAtt{
    GKReadSetModel *model = [GKReadManager shareInstance].model;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:model.lineSpacing];//段落 行间距
    paragraphStyle.firstLineHeadIndent  = model.firstLineHeadIndent;//首行缩进
    paragraphStyle.paragraphSpacingBefore = model.paragraphSpacingBefore; //段间距，当前段落和上个段落之间的距离。
    paragraphStyle.paragraphSpacing = model.paragraphSpacing; //段间距，当前段落和下个段落之间的距离。
    paragraphStyle.alignment = NSTextAlignmentJustified;//两边对齐
    paragraphStyle.allowsDefaultTighteningForTruncation = YES;
    NSDictionary *dic =  @{NSForegroundColorAttributeName:model.color,
                           NSFontAttributeName:[UIFont systemFontOfSize:model.font weight:model.weight],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    return dic;
}
+ (UIImage *)defaultBackView{
    GKReadState state = [GKReadManager shareInstance].model.state;
    NSString *image = nil;
    switch (state) {
        case GKReadNight:
            image = @"icon_read_night";
            break;
        case GKReadGreen:
            image = @"icon_read_green";
            break;
        case GKReadCaffee:
            image = @"icon_read_coffee";
            break;
        case GKReadPink:
            image = @"icon_read_pink";
            break;
        default:
            break;
    }
    return image ? [UIImage imageNamed:image] : [UIImage imageWithColor:[UIColor whiteColor]];
}

+ (BOOL)saveReadSetModel:(GKReadSetModel *)model{
    [GKReadManager shareInstance].model = model;
    BOOL res = NO;
    NSData *userData = [BaseModel archivedDataForData:model];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:gkReadModel];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
- (GKReadSetModel *)model{
    if (!_model) {
        _model = [[GKReadSetModel alloc] init];
        _model.font = 20;
        _model.lineSpacing = 10;
        _model.firstLineHeadIndent = 30;
        _model.paragraphSpacingBefore = 10;
        _model.paragraphSpacing = 10;
        _model.color = Appx999999;
        _model.weight = UIFontWeightLight;
        _model.state = GKReadDefault;
        _model.brightness = 0.5f;
    }
    return _model;
}
@end
