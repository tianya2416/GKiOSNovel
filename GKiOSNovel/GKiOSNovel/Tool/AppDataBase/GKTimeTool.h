//
//  GKTimeTool.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKTimeTool : NSObject
+ (NSString *)timeStampTurnToTimesType:(NSString *)timesTamp;
/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertSimplifiedToTraditional:(NSString *)simpString;

/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString*)convertTraditionalToSimplified:(NSString*)tradString;
@end

NS_ASSUME_NONNULL_END
