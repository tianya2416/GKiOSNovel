//
//  BaseModel.m
//
//  Created by Ljw .
//  Copyright © 2016年 Ljw. All rights reserved.
//


#import "BaseModel.h"
#import <YYKit/NSObject+YYModel.h>

@interface BaseModel ()
@end


@implementation BaseModel
    
#pragma mark - Coding/Copying/hash/equal/description
    
    // 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}
- (NSUInteger)hash {
    return [self modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}
- (NSString *)description {
    return [self modelDescription];
}
    
    
    
#pragma mark - Attributes
    // 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    //    return @{@"shadows" : [Shadow class],
    //             @"borders" : Border.class,
    //             @"attachments" : @"Attachment" };
    return nil;
}
    
    //返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    //    return @{@"name" : @"n",
    //             @"page" : @"p",
    //             @"desc" : @"ext.desc",
    //             @"bookID" : @[@"id",@"ID",@"book_id"]};
    return nil;
}
    
    
#pragma mark - 黑名单与白名单
    // 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return nil;
}
    // 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return nil;
}
    
    
    
#pragma mark - 数据校验与自定义转换
    // 当 JSON 转为 Model 完成后，该方法会被调用。
    // 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
    // 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    return YES;
}
    
    // 当 Model 转为 JSON 完成后，该方法会被调用。
    // 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
    // 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    
    return YES;
}
#pragma mark archived and unarchive
+ (NSData *)archivedDataForData:(id)data
{
    NSData * resData = nil;
    @try {
        resData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resData = nil;
    }
    @finally {
        
    }
    return resData;
}
+ (id)unarchiveForData:(NSData*)data
{
    id resObj = nil;
    @try {
        resObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resObj = nil;
    }
    @finally {
        
    }
    return resObj;
}
    
    
    @end







