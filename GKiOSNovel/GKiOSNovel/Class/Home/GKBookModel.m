//
//  GKBookModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookModel.h"

@implementation GKBookModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"majorCate" : @[@"majorCate",@"cat"]};
}
- (void)setUpdateTime:(NSString *)updateTime{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if (updateTime.length == 0) {
        _updateTime = timeSp;
    }else {
        _updateTime = updateTime;
    }
}
@end


@implementation GKBookInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : GKBookModel.class,@"listData":GKBookModel.class};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listData" : @"books",
             @"books" : @"books"};
}

- (void)setListData:(NSArray<GKBookModel *> *)listData{
    if (listData.count <= 6) {
        _listData = listData;
    }else{
//        NSInteger index = arc4random() % (listData.count - 6);
        _listData = [listData subarrayWithRange:NSMakeRange(0, 6)];
    }
}
@end
