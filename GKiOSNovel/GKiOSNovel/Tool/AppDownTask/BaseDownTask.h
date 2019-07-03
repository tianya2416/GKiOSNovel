//
//  BaseDownTask.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDownTask : NSObject
/**
 @brief 文件下载
 @param downUrl 要下载的url
 @param targetPath 下载存放的目录
 @param progress 进度
 @param completion 下载完成回调
 @return NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)baseDownload:(NSString *)downUrl
                                targetPath:(NSString *)targetPath
                                  progress:(void (^)(NSProgress *pro))progress
                                completion:(void (^)(NSURL *filePath, NSError *error))completion;
+ (NSString *)downloadPath;
@end

NS_ASSUME_NONNULL_END
