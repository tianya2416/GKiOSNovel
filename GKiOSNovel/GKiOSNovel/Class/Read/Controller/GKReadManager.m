//
//  GKReadManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadManager.h"

@implementation GKReadManager
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
- (instancetype)init{
    if (self = [super init]) {
        self.font = 20;
        self.lineSpacing = 10;
        self.firstLineHeadIndent = 30;
        self.paragraphSpacingBefore = 10;
        self.paragraphSpacing = 10;
        self.color = Appx999999;
        self.weight = UIFontWeightLight;
        self.state = GKReadDefault;
    }return self;
}
+ (void)startReset{
    
}
+ (NSDictionary *)attDictionary{
    GKReadManager *read = [GKReadManager shareInstance];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:read.lineSpacing];//段落 行间距
    paragraphStyle.firstLineHeadIndent  = read.firstLineHeadIndent;//首行缩进
    paragraphStyle.paragraphSpacingBefore = read.paragraphSpacingBefore; //段间距，当前段落和上个段落之间的距离。
    paragraphStyle.paragraphSpacing = read.paragraphSpacing; //段间距，当前段落和下个段落之间的距离。
    paragraphStyle.alignment = NSTextAlignmentJustified;//两边对齐
    paragraphStyle.allowsDefaultTighteningForTruncation = YES;
    NSDictionary *dic =  @{NSForegroundColorAttributeName:read.color,
                           NSFontAttributeName:[UIFont systemFontOfSize:read.font weight:read.weight],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    return dic;
}
+ (UIImage *)getReadImage:(GKReadState)state{
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
@end
