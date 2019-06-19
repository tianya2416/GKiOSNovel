//
//  GKBookContentModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookContentModel : BaseModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *traditional;//body对于繁体
@property (copy, nonatomic) NSString *created;
@property (copy, nonatomic) NSString *updated;

@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) NSInteger order;//章节
@property (assign, nonatomic) NSInteger currency;

@property (assign, nonatomic,readonly) NSInteger pageCount;

- (void)setContentPage;
- (NSAttributedString *)getContentAtt:(NSInteger)page;
@end

@interface GKBookContentInfo : BaseModel

@property (strong, nonatomic)NSMutableArray <GKBookContentModel *>*listData;
@property (assign, nonatomic,readonly) NSInteger totalPage;

//- (void)addObjectsFromArray:(NSArray *)
@end

NS_ASSUME_NONNULL_END
