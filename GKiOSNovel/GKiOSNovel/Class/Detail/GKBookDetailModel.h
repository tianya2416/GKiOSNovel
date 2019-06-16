//
//  GKBookDetailModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookModel.h"
#import "GKClassItemModel.h"
NS_ASSUME_NONNULL_BEGIN
@class GKBookDetailModel,GKBookListModel;
@interface GKBookDetailInfo : BaseModel
@property (nonatomic, strong)GKBookDetailModel *bookModel;
@property (nonatomic, strong)NSArray *listData;
+ (void)bookDetail:(NSString *)bookId
           success:(void(^)(GKBookDetailInfo *info))success
           failure:(void(^)(NSString *error))failure;
@end

@interface GKBookDetailModel : GKBookModel
@property (nonatomic, strong) NSString * cat;
@property (nonatomic, assign) NSInteger chaptersCount;
@property (nonatomic, strong) NSString * copyright;
@property (nonatomic, strong) NSString * creater;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, strong) NSArray * gender;
@property (nonatomic, assign) NSInteger latelyFollowerBase;
@property (nonatomic, strong) NSString * longIntro;
@property (nonatomic, assign) NSInteger minRetentionRatio;

@property (nonatomic, assign) NSInteger postCount;

@property (nonatomic, assign) NSInteger serializeWordCount;
@property (nonatomic, strong) NSDate * updated;
@property (nonatomic, assign) NSInteger wordCount;

@property (nonatomic, assign) BOOL hasSticky;       //置顶
@property (nonatomic, assign) BOOL hasUpdated;      //有更新
@property (nonatomic, assign) BOOL hasCp;
@property (nonatomic, assign) BOOL isSerial;
@property (nonatomic, assign) BOOL donate;
@property (nonatomic, assign) BOOL le;
@property (nonatomic, assign) BOOL allowBeanVoucher;
@property (nonatomic, assign) BOOL allowVoucher;

@property (nonatomic, assign) CGFloat height;

@end
@interface GKBookListModel : BaseModel
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *covers;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) NSInteger bookCount;
@property (nonatomic, assign) NSInteger collectorCount;
@end
NS_ASSUME_NONNULL_END
