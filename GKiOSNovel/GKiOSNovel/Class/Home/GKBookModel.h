//
//  GKBookModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookModel : BaseModel

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *shortIntro;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *site;
@property (copy, nonatomic) NSString *majorCate;
@property (copy, nonatomic) NSString *minorCate;

@property (assign, nonatomic) BOOL allowMonthly;
@property (assign, nonatomic) NSInteger banned;
@property (assign, nonatomic) NSInteger latelyFollower;
@property (assign, nonatomic) CGFloat retentionRatio;

@property (copy, nonatomic) NSString *contentType;
@property (copy, nonatomic) NSString *lastChapter;
@property (copy, nonatomic) NSString *superscript;

@property (assign, nonatomic) NSInteger sizetype;
@property (strong, nonatomic) NSArray<NSString *> *tags;

@end

@interface GKBookInfo : BaseModel

@property (strong, nonatomic) NSArray <GKBookModel *>*books;
@property (assign, nonatomic) NSInteger total;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *shortTitle;

@property (assign, nonatomic) NSInteger bookSort;

@end
NS_ASSUME_NONNULL_END
