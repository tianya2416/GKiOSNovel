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

@property (copy, nonatomic)   NSString *bookId;//书本id
@property (copy, nonatomic)   NSString *updateTime;//最近观看时间
@property (assign, nonatomic) NSInteger chapter;//读到第几章
@property (assign, nonatomic) NSInteger pageIndex;//读到第几页
@property (strong, nonatomic) GKBookDetailModel *bookModel;//书本基本信息
@property (strong, nonatomic) GKBookSourceInfo  *sourceInfo;//文章来源
@property (strong, nonatomic) GKBookChapterInfo *chapterInfo;//文章章节列表

@end

NS_ASSUME_NONNULL_END
