//
//  GKBookListModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookListDetailModel.h"

@implementation GKBookListDetailModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : GKBooksModel.class};
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"books" : @"n"};
//}

@end


@implementation GKAuthorModel
- (NSString *)avatar{
    return kBaseUrlIcon(_avatar?:@"");
}
@end

@implementation GKBooksModel

@end
