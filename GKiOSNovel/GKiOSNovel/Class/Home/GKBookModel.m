//
//  GKBookModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookModel.h"

@implementation GKBookModel
- (void)setCover:(NSString *)cover{
    if ([cover hasPrefix:@"/agent/"]) {
        cover = [cover stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }
    cover =  [cover stringByURLDecode];
    _cover = cover;
}
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

//- (void)setListData:(NSArray<GKBookModel *> *)listData{
//    if (listData.count <= 6) {
//        _listData = listData;
//    }else{
////        NSInteger index = arc4random() % (listData.count - 6);
//        _listData = [listData subarrayWithRange:NSMakeRange(0, 6)];
//    }
//}
- (NSArray *)listData{
    CGFloat count = self.state == GKBookInfoStateDefault ? 6 : 3;
    return (self.books.count <=count) ? self.books: [self.books subarrayWithRange:NSMakeRange(0,count)];
}
- (BOOL)moreData{
    CGFloat count = self.state == GKBookInfoStateDefault ? 6 : 3;
    return self.books.count > count;
}
@end
