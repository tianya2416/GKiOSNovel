//
//  GKHomeNetManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKHomeNetManager : NSObject

- (void)homeNet:(NSArray <GKRankModel *>*)listData loadData:(GKLoadDataState)loadData success:(void(^)(NSArray <GKBookInfo *>*datas))success failure:(void(^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
