//
//  GKBookReadModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKBookSourceModel.h"
#import "GKBookChapterModel.h"
#import "GKBookContentModel.h"
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookReadModel : BaseModel

@property (copy, nonatomic)   NSString *bookId;
@property (copy, nonatomic)   NSString *updateTime;
@property (assign, nonatomic) BOOL bookMarks;
@property (strong, nonatomic) GKBookDetailModel *bookModel;
@property (strong, nonatomic) GKBookSourceInfo *bookSource;//文章来源
@property (strong, nonatomic) GKBookChapterModel *bookChapter;//文章章节
@property (strong, nonatomic) GKBookContentModel *bookContent;//文章内容

+ (instancetype)vcWithBookId:(NSString *)bookId bookSource:(GKBookSourceInfo *)bookSource bookChapter:(GKBookChapterModel *)bookChapter bookContent:(GKBookContentModel *)bookContent bookModel:(GKBookDetailModel *)bookModel;
@end

NS_ASSUME_NONNULL_END
