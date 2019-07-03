//
//  GKBookCacheDataQueue.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKBookContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookCacheDataQueue : NSObject
+ (void)insertDataToDataBase:(NSString *)bookId
                       model:(GKBookContentModel *)model
                  completion:(void(^)(BOOL success))completion;
+ (void)insertDatasDataBase:(NSString *)bookId
                   listData:(NSArray <GKBookContentModel*>*)listData
                 completion:(void(^)(BOOL success))completion;
+ (void)getDataFromDataBase:(NSString *)bookId
                  contentId:(NSString *)contentId
                 completion:(void(^)(GKBookContentModel *bookModel))completion;
+ (void)getDatasFromDataBase:(NSString *)bookId
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <GKBookContentModel *>*listData))completion;
+ (void)dropTableFromDataBase:(NSString *)bookId
                   completion:(void(^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
