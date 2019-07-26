//
//  BaseDownFont.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDownFont : NSObject
+ (void)downFontName:(NSString *)fontName progress:(void(^)(CGFloat progress))progress completion:(void (^)(NSURL *filePath, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
