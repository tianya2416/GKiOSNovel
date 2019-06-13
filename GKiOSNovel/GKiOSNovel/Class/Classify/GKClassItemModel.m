//
//  GKClassModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKClassItemModel.h"

@implementation GKClassItemModel
- (NSString *)icon{
    return self.bookCover.firstObject;
}
@end

