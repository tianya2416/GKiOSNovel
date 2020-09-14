//
//  YCollectionViewLayout.h
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/8.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,GKLayoutStyle) {
    GKLayoutStyleTag,
    GKLayoutStyleCommend,
};

@interface GKCollectionViewLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSArray <NSString *>*dataArr;

+ (instancetype)vcWithStyle:(GKLayoutStyle)style;
@end
