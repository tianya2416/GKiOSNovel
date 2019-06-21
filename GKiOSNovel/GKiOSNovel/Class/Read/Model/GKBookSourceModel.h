//
//  GKBookSourceModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBookSourceModel : BaseModel
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *lastChapter;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *starting;
@property (assign, nonatomic) NSInteger chaptersCount;
@property (assign, nonatomic) NSInteger isCharge;
@end

@interface GKBookSourceInfo : BaseModel;

@property (copy, nonatomic) NSString *bookSourceId;
@property (assign, nonatomic) NSInteger sourceIndex;

@property (strong, nonatomic) NSArray <GKBookSourceModel*>*listData;

@end

NS_ASSUME_NONNULL_END
