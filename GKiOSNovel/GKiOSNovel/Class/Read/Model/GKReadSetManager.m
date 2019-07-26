//
//  GKReadManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadSetManager.h"
#import "BaseDownFont.h"
static NSString *gkReadModel = @"gkReadModel";

@interface GKReadSetManager()
@property (strong, nonatomic) GKReadSetModel *model;
@property (strong, nonatomic) NSString *simplifiedStr;
@property (strong, nonatomic) NSString *traditionalStr;
@end
@implementation GKReadSetManager

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

+ (void)setLandscape:(BOOL)landscape{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.landscape != landscape) {
        model.landscape = landscape;
        [GKReadSetManager saveReadSetModel:model];
    }
}

+ (void)setTraditiona:(BOOL)traditiona{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.traditiona != traditiona) {
        model.traditiona = traditiona;
        [GKReadSetManager saveReadSetModel:model];
    }
}
+ (void)setBrowseState:(GKBrowseState)browseState{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.browseState != browseState) {
        model.browseState = browseState;
        [GKReadSetManager saveReadSetModel:model];
    }
}
+ (void)setReadState:(GKReadThemeState)state{
    
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.state != state) {
        model.state = state;
        [GKReadSetManager saveReadSetModel:model];
    }
}
+ (void)setBrightness:(CGFloat)brightness{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.brightness != brightness) {
        model.brightness = brightness;
        [GKReadSetManager saveReadSetModel:model];
    }
}
+ (void)setFont:(CGFloat )font{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (model.font != font) {
        model.font = font;
        [GKReadSetManager saveReadSetModel:model];
    }
}
+ (void)setFontName:(NSString *)fontName{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if (![model.fontName isEqualToString:fontName]) {
        model.fontName = fontName;
        [GKReadSetManager saveReadSetModel:model];
    }
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
+ (NSString *)convertToTraditional:(NSString *)simpString{
    if (simpString.length == 0) {
        return nil;
    }
    NSString *sim = [GKReadSetManager shareInstance].simplifiedStr;
    NSString *tra = [GKReadSetManager shareInstance].traditionalStr;
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
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
//    NSArray *fonts = [UIFont familyNames];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self like %@",model.fontName];
//    NSArray *filterdArray = [fonts filteredArrayUsingPredicate:predicate];
//    if (filterdArray.count == 0) {
//        model.fontName = [BaseMacro fontName];
//        [GKReadSetManager setFontName:[BaseMacro fontName]];
//    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:model.lineSpacing];//段落 行间距
    paragraphStyle.firstLineHeadIndent  = model.firstLineHeadIndent;//首行缩进
    paragraphStyle.paragraphSpacingBefore = model.paragraphSpacingBefore; //段间距，当前段落和上个段落之间的距离。
    paragraphStyle.paragraphSpacing = model.paragraphSpacing; //段间距，当前段落和下个段落之间的距离。
    paragraphStyle.alignment = NSTextAlignmentJustified;//两边对齐
    paragraphStyle.allowsDefaultTighteningForTruncation = YES;
    NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor colorWithHexString:model.color ?:@"999999"],
                           NSFontAttributeName:[UIFont fontWithName:model.fontName ?: @"PingFangSC-Light" size:model.font ?: 20],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    return dic;
}
+ (UIImage *)defaultSkin{
    GKReadThemeState state = [GKReadSetManager shareInstance].model.state;
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
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:gkReadModel];
    _model = data ? [BaseModel unarchiveForData:data]: [GKReadSetModel new];
    return _model;
}

@end
