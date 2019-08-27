//
//  GKSetManager.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/7/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSetManager.h"
static NSString *gkReadModel = @"gkReadModel";

@interface GKSetManager()
@property (strong, nonatomic) GKSet *model;
@property (strong, nonatomic) NSString *simplifiedStr;
@property (strong, nonatomic) NSString *traditionalStr;
@end
@implementation GKSetManager
+ (instancetype )shareInstance
{
    static GKSetManager * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
#pragma mark class set
+ (void)setNight:(BOOL)night{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.night != night) {
        model.night = night;
        NSString *color = (night || model.state == GKReadCaffee)?@"999999":@"333333";
        model.color = color;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setLandscape:(BOOL)landscape{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.landscape != landscape) {
        model.landscape = landscape;
        [GKSetManager saveSetModel:model];
    }
}

+ (void)setTraditiona:(BOOL)traditiona{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.traditiona != traditiona) {
        model.traditiona = traditiona;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setBrowseState:(GKBrowseState)browseState{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.browseState != browseState) {
        model.browseState = browseState;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setReadState:(GKSkinState)state{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.state != state) {
        model.state = state;
        NSString *color = (state == GKReadCaffee)?@"999999":@"333333";
        model.color = color;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setBrightness:(CGFloat)brightness{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.brightness != brightness) {
        model.brightness = brightness;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setFont:(CGFloat )font{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.font != font) {
        model.font = font;
        [GKSetManager saveSetModel:model];
    }
}
+ (void)setFontName:(NSString *)fontName{
    GKSet *model = [GKSetManager shareInstance].model;
    if (![model.fontName isEqualToString:fontName]) {
        model.fontName = fontName;
        [GKSetManager saveSetModel:model];
    }
}
+ (BOOL)saveSetModel:(GKSet *)model{
    [GKSetManager shareInstance].model = model;
    BOOL res = NO;
    NSData *userData = [BaseModel archivedDataForData:model];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:gkReadModel];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
+ (NSString *)convertToTraditional:(NSString *)simpString{
    if (simpString.length == 0) {
        return nil;
    }
    NSString *sim = [GKSetManager shareInstance].simplifiedStr;
    NSString *tra = [GKSetManager shareInstance].traditionalStr;
    NSMutableString *resultString = [[NSMutableString alloc] init];
    // 遍历字符串中的字符
    NSInteger length = [simpString length];
    for (NSInteger i = 0; i < length; i++)
    {
        // 在简体中文中查找字符位置，如果存在则取出对应的繁体中文
        NSString *simCharString = [simpString substringWithRange:NSMakeRange(i, 1)];
        NSRange charRange = [sim rangeOfString:simCharString];
        if(charRange.location != NSNotFound) {
            NSString *tradCharString = [tra substringWithRange:charRange];
            tradCharString ? [resultString appendString:tradCharString] : nil;
        }else{
            simCharString ? [resultString appendString:simCharString] : nil;
        }
    }
    return resultString;
}
#pragma mark class get
- (NSString *)simplifiedStr {
    if (!_simplifiedStr) {
        _simplifiedStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SimplifiedCode" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return _simplifiedStr;
}

- (NSString *)traditionalStr {
    if (!_traditionalStr) {
        _traditionalStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"TraditionalCode" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return _traditionalStr;
}
+ (NSDictionary *)defaultFont{
    GKSet *model = [GKSetManager shareInstance].model;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:model.lineSpacing];//段落 行间距
    paragraphStyle.firstLineHeadIndent  = model.firstLineHeadIndent;//首行缩进
    paragraphStyle.paragraphSpacingBefore = model.paragraphSpacingBefore; //段间距，当前段落和上个段落之间的距离。
    paragraphStyle.paragraphSpacing = model.paragraphSpacing; //段间距，当前段落和下个段落之间的距离。
    paragraphStyle.alignment = NSTextAlignmentJustified;//两边对齐
    paragraphStyle.allowsDefaultTighteningForTruncation = YES;
    NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor colorWithHexString:model.color ?:@"999999"],
                           NSFontAttributeName:[UIFont fontWithName:model.fontName ?: [BaseMacro fontName] size:model.font ?: 20],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    return dic;
}
+ (UIImage *)defaultSkin{
    GKSet *model = [GKSetManager shareInstance].model;
    if (model.night) {
        return [UIImage imageNamed:@"icon_read_black"] ;
    }else{
        GKSkinState state = model.state;
        NSArray *listData = [GKSetManager defaultSkinDatas];
        GKSkin *model = [listData objectSafeAtIndex:state];
        return [UIImage imageNamed:model.skin] ;
    }
}

+ (NSArray *)defaultSkinDatas{
    GKSkin *model = [GKSkin vcWithTitle:@"默认" skin:@"icon_read_yellow" state:GKReadDefault];
    GKSkin *model2 = [GKSkin vcWithTitle:@"翠绿色" skin:@"icon_read_green" state:GKReadGreen];
    GKSkin *model3 = [GKSkin vcWithTitle:@"咖啡色" skin:@"icon_read_coffee" state:GKReadCaffee];
    GKSkin *model4 = [GKSkin vcWithTitle:@"淡粉色" skin:@"icon_read_fenweak" state:GKReadPink];
    GKSkin *model5 = [GKSkin vcWithTitle:@"粉红色" skin:@"icon_read_fen" state:GKReadFen];
    GKSkin *model6 = [GKSkin vcWithTitle:@"紫色" skin:@"icon_read_zi" state:GKReadZi];
    //GKSkin *model7 = [GKSkin vcWithTitle:@"黄色" skin:@"icon_read_yellow" state:GKReadYellow];
    return @[model,model2,model3,model4,model5,model6];
}
#pragma mark get
- (GKSet *)model{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkReadModel];
    _model = data ? [BaseModel unarchiveForData:data]: [GKSet new];
    return _model;
}
@end
