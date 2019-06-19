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
- (NSDictionary *)readDictionary{
    if (!_readDictionary) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];//段落 行间距
        paragraphStyle.firstLineHeadIndent  = 30;//首行缩进
        paragraphStyle.paragraphSpacingBefore = 10; //段间距，当前段落和上个段落之间的距离。
        paragraphStyle.paragraphSpacing = 10; //段间距，当前段落和下个段落之间的距离。
        paragraphStyle.alignment = NSTextAlignmentJustified;//两边对齐
        paragraphStyle.allowsDefaultTighteningForTruncation = YES;
        _readDictionary =  @{NSForegroundColorAttributeName:Appx999999,
                             NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightLight],
                             NSParagraphStyleAttributeName:paragraphStyle
                             };
    }
    return _readDictionary;
}
@end
