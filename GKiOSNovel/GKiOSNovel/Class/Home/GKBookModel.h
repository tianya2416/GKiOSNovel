//
//  GKBookModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GKBookInfoState) {
    GKBookInfoStateDefault   =  0,//网络数据
    GKBookInfoStateDataQueue =  1,//本地数据 = 2,
};
@interface GKBookModel : BaseModel

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *updateTime;

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

@property (strong, nonatomic) NSArray  *books;//所有数据 GKBookModel
@property (assign, nonatomic) NSInteger total;//数据个数
@property (copy, nonatomic) NSString *title;//标题
@property (copy, nonatomic) NSString *shortTitle;//标题
@property (copy, nonatomic) NSString *_id;//Id

@property (assign, nonatomic) NSInteger bookSort;//用于排序
@property (assign, nonatomic) GKBookInfoState state;//区分本地还是服务端数据
@property (assign, nonatomic) BOOL moreData;//是否有更多数据

@property (strong, nonatomic) NSArray <GKBookModel *>*listData;//首页用于显示 一般下6个
@end
NS_ASSUME_NONNULL_END
