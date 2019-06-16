//
//  GKClassModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKClassItemModel : BaseModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *monthlyCount;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) NSInteger bookCount;
@property (strong, nonatomic) NSArray *bookCover;

@end


NS_ASSUME_NONNULL_END
