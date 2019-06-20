//
//  GKBookChapterModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookChapterModel : BaseModel
@property (copy, nonatomic) NSString *chapterCover;

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *isVip;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) NSInteger order;
@property (assign, nonatomic) NSInteger chapterIndex;
@property (assign, nonatomic) NSInteger partsize;
@property (assign, nonatomic) NSInteger totalpage;
@property (assign, nonatomic) NSInteger currency;
@end

@interface GKBookChapterInfo : BaseModel

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *source;

@property (copy, nonatomic) NSString *updated;
@property (copy, nonatomic) NSString *book;
@property (copy, nonatomic) NSString *starting;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray <GKBookChapterModel *>*chapters;

@end

NS_ASSUME_NONNULL_END
