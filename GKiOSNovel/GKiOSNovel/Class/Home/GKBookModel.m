//
//  GKBookModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookModel.h"

@implementation GKBookModel

@end


@implementation GKBookInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : GKBookModel.class};
}
- (void)setBooks:(NSArray<GKBookModel *> *)books{
    _books = (books.count > 6) ? [books subarrayWithRange:NSMakeRange(0, 6)] : books;
}
@end
