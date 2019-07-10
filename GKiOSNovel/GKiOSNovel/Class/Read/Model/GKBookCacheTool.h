//
//  GKBookCacheTool.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKBookSourceModel.h"
#import "GKBookChapterModel.h"
#import "GKBookContentModel.h"

@interface GKBookCacheTool : NSObject
@property (assign, nonatomic) BOOL download;//f是否正在下载
//下中数据回调
- (void)downloadData:(NSString *)bookId
            progress:(void (^)(NSInteger index,NSInteger total))progress
          completion:(void (^)(BOOL finish,NSString *error))completion;
//先从已下载中读取数据
+ (void)bookContent:(NSString *)url
          contentId:(NSString *)contentId
             bookId:(NSString *)bookId
         sameSource:(NSInteger )sameSource
            success:(void(^)(GKBookContentModel *model))success
            failure:(void(^)(NSString *error))failure;

@end


