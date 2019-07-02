//
//  GKReadManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadSetManager.h"
static NSString *gkReadModel = @"gkReadModel";

@implementation GKReadSkinModel
+ (instancetype)vcWithTitle:(NSString *)title skin:(NSString *)skin state:(GKReadState)state{
    GKReadSkinModel *vc = [[[self class] alloc] init];
    vc.title = title;
    vc.skin = skin;
    vc.state = state;
    return vc;
}
@end
@implementation GKReadSetModel

@end
@interface GKReadSetManager()
@property (strong, nonatomic)GKReadSetModel *model;
@end
@implementation GKReadSetManager
- (instancetype)init{
    if (self = [super init]) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkReadModel];
        _model = data ? [BaseModel unarchiveForData:data]: nil;
    }
    return self;
}
+ (instancetype )shareInstance
{
    static GKReadSetManager * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
#pragma mark class set
+ (void)setReadState:(GKReadState)state{
    
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    model.state = state;
    [GKReadSetManager saveReadSetModel:model];
}
+ (void)setBrightness:(CGFloat)brightness{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    model.brightness = brightness;
    [GKReadSetManager saveReadSetModel:model];
}
+ (void)setFont:(CGFloat )font{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    model.font = font;
    model.weight = UIFontWeightLight;
    [GKReadSetManager saveReadSetModel:model];
}
+ (BOOL)saveReadSetModel:(GKReadSetModel *)model{
    [GKReadSetManager shareInstance].model = model;
    BOOL res = NO;
    NSData *userData = [BaseModel archivedDataForData:model];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:gkReadModel];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
#pragma mark class get
+ (NSDictionary *)defaultFont{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
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
+ (UIImage *)defaultSkin{
    GKReadState state = [GKReadSetManager shareInstance].model.state;
    NSArray *listData = [GKReadSetManager defaultSkinDatas];
    GKReadSkinModel *model = [listData objectSafeAtIndex:state];
    return [UIImage imageNamed:model.skin] ;
}

+ (NSArray *)defaultSkinDatas{
    GKReadSkinModel *model = [GKReadSkinModel vcWithTitle:@"粉白色" skin:@"icon_read_white" state:GKReadDefault];
    GKReadSkinModel *model1 = [GKReadSkinModel vcWithTitle:@"黑色" skin:@"icon_read_black" state:GKReadBlack];
    GKReadSkinModel *model2 = [GKReadSkinModel vcWithTitle:@"翠绿色" skin:@"icon_read_green" state:GKReadGreen];
    GKReadSkinModel *model3 = [GKReadSkinModel vcWithTitle:@"咖啡色" skin:@"icon_read_coffee" state:GKReadCaffee];
    GKReadSkinModel *model4 = [GKReadSkinModel vcWithTitle:@"淡粉色" skin:@"icon_read_fenweak" state:GKReadPink];
    GKReadSkinModel *model5 = [GKReadSkinModel vcWithTitle:@"粉红色" skin:@"icon_read_fen" state:GKReadFen];
    GKReadSkinModel *model6 = [GKReadSkinModel vcWithTitle:@"紫色" skin:@"icon_read_zi" state:GKReadZi];
    GKReadSkinModel *model7 = [GKReadSkinModel vcWithTitle:@"黄色" skin:@"icon_read_yellow" state:GKReadYellow];
    return @[model,model1,model2,model3,model4,model5,model6,model7];
}
#pragma mark get
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
        _model.brightness = [[UIScreen mainScreen] brightness];
    }
    return _model;
}
@end
