//
//  GKReadManager.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKReadManager : NSObject
@property (strong, nonatomic) NSDictionary *readDictionary;
+ (instancetype )shareInstance;
@end

NS_ASSUME_NONNULL_END
