//
//  GKSearchDataQueue.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchDataQueue.h"


static NSString *SearchTable = @"SearchTable";

@interface GKSearchDataQueue()


@end



@implementation GKSearchDataQueue
+ (void)tableExists:(FMDatabase *)dataBase{
    if (![dataBase tableExists:SearchTable]) {
        if ([dataBase open]) {
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (id integer PRIMARY KEY AUTOINCREMENT NOT NULL,name varchar(128) NOT NULL,updateTime integer(10) NOT NULL)",SearchTable];
            if ([dataBase executeUpdate:sql]) {
                NSLog(@"create table success");
            }
            [dataBase close];
        }
    }
}
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(NSString *)hotWord
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [GKSearchDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [GKSearchDataQueue tableExists:db];
            if ([db open]) {
                NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where name='%@'",SearchTable,hotWord];
                FMResultSet *s = [db executeQuery:sql];
                BOOL res = NO;
                if ([s next]) {
                    int totalCount = [s intForColumnIndex:0];
                    res = totalCount > 0;
                }
                NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
                if (res) {
                    sql = [NSString stringWithFormat:@"update %@ set updateTime = '%ld' where name='%@'",SearchTable,(long)time,hotWord];
                }else{
                    sql = [NSString stringWithFormat:@"insert or replace into '%@' (name,updateTime) values ('%@','%ld')",SearchTable ?: @"",hotWord?:@"",(long)time];
                }
                res = [db executeUpdate:sql];
                if (res) {
                    NSLog(@"insert or replace into success");
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(res);
                });
            }
        }];
    });
}
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(NSString *)hotWord
                  completion:(void(^)(BOOL success))completion{
    //根据hotWord 更新时间
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [GKSearchDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [GKSearchDataQueue tableExists:db];
            if ([db open]) {
                NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
                NSString * v5TableSql = [NSString stringWithFormat:@"update %@ set updateTime = '%ld'  where name = '%@'",SearchTable ?:@"",(long)time,hotWord];
                BOOL res = [db executeUpdate:v5TableSql];
                if (res) {
                    NSLog(@"insert or replace into success");
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(res);
                });
            }
        }];
    });
}
/**
 *  @brief 数据删除
 */
+ (void)deleteDataToDataBase:(NSString *)hotWord
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [GKSearchDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [GKSearchDataQueue tableExists:db];
            if ([db open]) {
                NSString * v5TableSql = [NSString stringWithFormat:@"delete from '%@' where name = '%@'",SearchTable ?:@"",hotWord?: @""];
                BOOL res = [db executeUpdate:v5TableSql];
                if (res) {
                    NSLog(@"insert or replace into success");
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(res);
                });
            }
        }];
    });
}
+ (void)deleteDatasToDataBase:(NSArray *)listData
                   completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GKSearchDataQueue *dataBase = [GKSearchDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [GKSearchDataQueue tableExists:db];
            if ([db open]) {
                [db beginTransaction];
                for (NSString * hotWord in listData) {
                    NSString * v5TableSql = [NSString stringWithFormat:@"delete from '%@' where name = '%@'",SearchTable ?:@"",hotWord ?: @""];
                    BOOL res = [db executeUpdate:v5TableSql];
                    if (res) {
                        NSLog(@"insert or replace into success");
                    }
                }
                BOOL success = [db commit];
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(success);
                });
            }
        }];
    });
}
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(NSInteger )page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <NSString *>*listData))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GKSearchDataQueue *dataBase = [GKSearchDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase *db) {
            [GKSearchDataQueue tableExists:db];
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from '%@' order by updateTime desc limit %@,%@",SearchTable,@((page-1)*pageSize),@(pageSize)];
                FMResultSet * rs = [db executeQuery:sql];
                NSString *name = nil;
                NSMutableArray * array = [[NSMutableArray alloc]init];
                while ([rs next])
                {
                    name = [rs stringForColumn:@"name"];
                    [array addObject:name?:@""];
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?:completion(array);
                });
            }
        }];
    });
}
+ (void)dropTableDataBase:(void (^)(BOOL))completion{
    [GKSearchDataQueue dropTableDataBase:SearchTable completion:completion];
}
@end
