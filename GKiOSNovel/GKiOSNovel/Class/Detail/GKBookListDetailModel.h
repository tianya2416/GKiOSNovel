//
//  GKBookListModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GKAuthorModel,GKBooksModel;

@interface GKBookListDetailModel : BaseModel
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *shareLink;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *gender;
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger collectorCount;
@property (assign, nonatomic) NSInteger updateCount;

@property (strong, nonatomic) NSArray <GKBooksModel *>*books;
@property (strong, nonatomic) GKAuthorModel *author;
@end

@interface GKAuthorModel :  BaseModel
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic) NSInteger lv;
@end

@interface GKBooksModel :  BaseModel
@property (copy, nonatomic) NSString *comment;
@property (strong, nonatomic) GKBookModel *book;
@end
NS_ASSUME_NONNULL_END
