//
//  GKHomeNetManager.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeNetManager.h"
@interface GKHomeNetManager()
@property (strong, nonatomic)NSMutableArray <GKBookInfo *>*arrayDatas;
@property (strong, nonatomic)NSMutableArray <GKBookInfo *>*listData;
@property (strong, nonatomic)GKBookInfo *bookCase;
@property (strong, nonatomic)GKBookInfo *readBook;
@end

@implementation GKHomeNetManager
- (void)homeNet:(NSArray <GKRankModel *>*)listData loadData:(GKLoadDataState)loadData success:(void(^)(NSArray <GKBookInfo *>*datas))success failure:(void(^)(NSString *error))failure{
    dispatch_group_t group = dispatch_group_create();
    if (loadData & GKLoadDataNetData) {
        [self.arrayDatas removeAllObjects];
        [listData enumerateObjectsUsingBlock:^(GKRankModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.rankSort = idx;
            dispatch_group_enter(group);
            [GKNovelNetManager homeHot:obj._id success:^(id  _Nonnull object) {
                GKBookInfo *info= [GKBookInfo modelWithJSON:object];
                if (info) {
                    info.bookSort = obj.rankSort;
                    [self.arrayDatas addObject:info];
                }
                dispatch_group_leave(group);
            } failure:^(NSString * _Nonnull error) {
                dispatch_group_leave(group);
            }];
        }];
    }
    if (loadData & GKLoadDataDataBase) {
        dispatch_group_enter(group);
        [GKBookReadDataQueue getDatasFromDataBase:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
            self.readBook = [[GKBookInfo alloc] init];
            self.readBook.state = GKBookInfoStateDataQueue;
            self.readBook.shortTitle = @"读书记录";
            self.readBook.books = listData;
            dispatch_group_leave(group);
        }];
//        dispatch_group_enter(group);
//        [GKBookCaseDataQueue getDatasFromDataBase:^(NSArray<GKBookDetailModel *> * _Nonnull listData) {
//            self.bookCase = [[GKBookInfo alloc] init];
//            self.bookCase.state = GKBookInfoStateDataQueue;
//            self.bookCase.shortTitle = @"我的书架";
//            self.bookCase.books = listData;
//            dispatch_group_leave(group);
//        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.listData removeAllObjects];
        if ( [YYReachability reachability].status != YYReachabilityStatusNone) {
            if (self.readBook.books.count > 0) {
                [self.listData addObject:self.readBook];
            }
            if (self.bookCase.books.count > 0) {
                [self.listData addObject:self.bookCase];
            }
            if (self.arrayDatas.count) {
                NSArray *datas = [GKHomeNetManager sortedArrayUsingComparator:self.arrayDatas.copy key:@"bookSort" ascending:YES];
                [self.listData addObjectsFromArray:datas];
            }
        }
        if (self.listData.count) {
            !success ?: success(self.listData.copy);
        }else{
            !failure ?:failure(@"");
        }
    });
}
+ (NSArray *)sortedArrayUsingComparator:(NSArray <GKBookInfo *>*)listData key:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key?:@"bookSort" ascending:ascending];
    return [listData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
- (NSMutableArray *)arrayDatas{
    if (!_arrayDatas) {
        _arrayDatas = @[].mutableCopy;
    }
    return _arrayDatas;
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = @[].mutableCopy;
    }
    return _listData;
}
@end
