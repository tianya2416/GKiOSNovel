//
//  GKBookDetailModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailModel.h"

@implementation GKBookDetailInfo
+ (instancetype)vcWithDatas:(NSArray *)datas{
    GKBookDetailInfo *vc = [[[self class] alloc] init];
    vc.listData = datas;
    return vc;
}
+ (void)bookDetail:(NSString *)bookId
           success:(void(^)(GKBookDetailInfo *info))success
           failure:(void(^)(NSString *error))failure{
    __block NSArray *list = nil;
    __block NSArray *books = nil;
    __block NSArray *booklists = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [GKNovelNetManager bookDetail:bookId success:^(id  _Nonnull object) {
        GKBookDetailModel *model = [GKBookDetailModel modelWithJSON:object];
        if (model) {
            list = @[model];
        }
        dispatch_group_leave(group);
    } failure:^(NSString * _Nonnull error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [GKNovelNetManager bookCommend:bookId success:^(id  _Nonnull object) {
        books = [NSArray modelArrayWithClass:GKBookModel.class json:object[@"books"]];
        if (books.count > 6) {
            NSInteger index = arc4random() % (books.count - 6);
            books = [books subarrayWithRange:NSMakeRange(index, 6)];
        }
        dispatch_group_leave(group);
    } failure:^(NSString * _Nonnull error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [GKNovelNetManager bookListCommend:bookId success:^(id  _Nonnull object) {
        booklists = [NSArray modelArrayWithClass:GKBookListModel.class json:object[@"booklists"]];
        dispatch_group_leave(group);
    } failure:^(NSString * _Nonnull error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([YYReachability reachability].status != YYReachabilityStatusNone) {
            if (list || books || booklists) {
                 NSMutableArray *datas = [[NSMutableArray alloc] init];
                if (list) {
                    [datas addObject:list];
                }
                if (books) {
                    [datas addObject:books];
                }
                if (booklists) {
                    [datas addObject:booklists];
                }
                GKBookDetailInfo *info = [GKBookDetailInfo vcWithDatas:datas.copy];
                info.bookModel = list.firstObject;
                !success ?: success(info);
            }else{
                !failure?: failure(@"");
            }
        }else{
            !failure?: failure(@"");
        }
    });
}
@end

@implementation GKBookDetailModel

@end

@implementation GKBookListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}
@end
