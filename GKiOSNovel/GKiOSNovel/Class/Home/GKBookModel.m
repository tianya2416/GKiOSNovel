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
@end


@implementation GKBookInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : GKBookModel.class,@"listData":GKBookModel.class};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listData" : @"books",
             @"books" : @"books"};
}
//- (void)setBooks:(NSArray<GKBookModel *> *)books{
//    if (books.count <= 6) {
//        _books = books;
//    }else{
//        NSInteger index = arc4random() % (books.count - 6);
//        _books = [books subarrayWithRange:NSMakeRange(index, 6)];
//    }
//}
- (void)setListData:(NSArray<GKBookModel *> *)listData{
    if (listData.count <= 6) {
        _listData = listData;
    }else{
        NSInteger index = arc4random() % (listData.count - 6);
        _listData = [listData subarrayWithRange:NSMakeRange(0, 6)];
    }
}
@end
