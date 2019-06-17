//
//  BaseMacro.h
//  YiCong
//
//  Created by wangws1990 on 2019/4/16.
//  Copyright © 2019 王炜圣. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppColor                 [UIColor colorWithRGB:0x66A2F9]
#define Appxdddddd               [UIColor colorWithRGB:0xDDDDDD]
#define Appx000000               [UIColor colorWithRGB:0x000000]
#define Appx333333               [UIColor colorWithRGB:0x333333]
#define Appx666666               [UIColor colorWithRGB:0x666666]
#define Appx999999               [UIColor colorWithRGB:0x999999]
#define Appxf8f8f8               [UIColor colorWithRGB:0xf8f8f8]
#define Appxffffff               [UIColor colorWithRGB:0xffffff]
#define AppRadius                4.0f
#define AppLineHeight            0.60f

#define placeholders     [UIImage imageNamed:@"placeholder_big"]
#define placeholdersmall [UIImage imageNamed:@"placeholder_small"]

#pragma mark login
#define BaseUrl  @"http://api.zhuishushenqi.com/"
#define BaseUrlIcon  @"https://statics.zhuishushenqi.com"

#define kBaseUrl(url)  [NSString stringWithFormat:@"%@%@", BaseUrl, url]
#define kBaseUrlIcon(url)  [NSString stringWithFormat:@"%@%@", BaseUrlIcon, url]

#define RefreshPageStart (1)
#define RefreshPageSize (35)

#ifdef DEBUG
#ifndef NSLog
//#   define NSLog(...)
#endif
#endif
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GKUserState) {
    GKUserBoy =  1,
    GKUserGirl = 2,
};
@interface BaseMacro : NSObject
+ (NSArray *)hotDatas;
@end
NS_ASSUME_NONNULL_END
