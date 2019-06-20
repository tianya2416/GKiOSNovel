//
//  GKBookReadModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookReadModel.h"

@implementation GKBookReadModel
+ (instancetype)vcWithBookId:(NSString *)bookId bookSource:(GKBookSourceInfo *)bookSource bookChapter:(GKBookChapterModel *)bookChapter bookContent:(GKBookContentModel *)bookContent bookModel:(GKBookDetailModel *)bookModel{
    GKBookReadModel *vc = [[[self class] alloc]init];
    vc.bookId = bookId;
    vc.bookChapter = bookChapter;
    vc.bookSource = bookSource;
    vc.bookContent = bookContent;
    vc.bookModel = bookModel;
    vc.updateTime = @"";
    return vc;
}
- (void)setUpdateTime:(NSString *)updateTime{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if (updateTime.length == 0) {
        _updateTime = timeSp;
    }else {
        _updateTime = updateTime;
    }
}
@end
