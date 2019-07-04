//
//  BaseDownTask.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDownTask.h"

@implementation BaseDownTask
+ (NSURLSessionDownloadTask *)baseDownload:(NSString *)downUrl
                                targetPath:(NSString *)targetPath
                                  progress:(void (^)(NSProgress *pro))progress
                                completion:(void (^)(NSURL *filePath, NSError *error))completion{
    assert(targetPath);
    assert(downUrl);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downUrl]];
    NSURLSessionDownloadTask *tast = [manger downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull path, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [targetPath stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"fullPath:%@",fullPath);
        NSLog(@"targetPath:%@",targetPath);
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        !completion ?: completion(filePath,error);
    }];
    [tast resume];
    return tast;
}
+ (NSString *)downloadPath{
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Caches/Download"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"create successful");
        }
    }
    return path;
}
@end
