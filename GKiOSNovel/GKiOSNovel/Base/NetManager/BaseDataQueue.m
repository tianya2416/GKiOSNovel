//
//  BaseDataQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"
#import <FMDB.h>

@interface BaseDataQueue()
@property (strong, nonatomic)FMDatabaseQueue *dataQueue;
@property(copy, nonatomic)NSString *tableName;
@property(copy, nonatomic)NSString *primaryId;
@end
@implementation BaseDataQueue
+ (instancetype )shareInstance
{
    static BaseDataQueue * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self createDateBaseTable];
    }
    return self;
}
- (void)createDateBaseTable
{
    if (self.tableName.length > 0 && self.primaryId.length > 0) {
        [self.dataQueue inDatabase:^(FMDatabase * dataBase) {
            if ([dataBase open]) {
                //数据库建表
                NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (data text,'%@' text PRIMARY KEY)",self.tableName,self.primaryId];
                [dataBase executeUpdate:sql];
                [dataBase close];
            }
            else
            {
                NSLog(@"dataBase open error");
            }
        }];
    }
}
+ (void)insertDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.tableName = tableName;
        dataBase.primaryId = primaryId;
        [dataBase createDateBaseTable];
        NSString *userId = userInfo[primaryId];
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase * db) {
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into '%@' (data,'%@') values (?,?)",tableName ?: @"",primaryId ?: @""];
                    BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                    if (res) {
                        NSLog(@"insert or replace into success");
                    }
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)updateDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        //[dataBase createDateBaseTable];
        NSString *userId = userInfo[primaryId];
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase * db) {
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    // NSString * v5TableSql = [NSString stringWithFormat:@"replace into '%@' (data,'%@') values (?,?)",tableName ?: @"",primaryId ?: @""];
                    NSString * v5TableSql = [NSString stringWithFormat:@"update %@ set data = ? where %@ = ?",tableName ?:@"", primaryId ?:@""];
                    BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                    if (res) {//update 'defaultTableManager' set data = ? where 'identy' = ?
                        NSLog(@"update success");
                    }
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)deleteDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                primaryValue:(NSString *)primaryValue
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        [dataBase createDateBaseTable];
        NSString *userId = primaryValue ?:@"";
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase *db) {
                if ([db open]) {
                    [db beginTransaction];
                    NSString * v5TableSql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",tableName ?:@"",primaryId?:@"",userId ?: @""];
                    BOOL res = [db executeUpdate:v5TableSql];
                    if (res) {
                        [db commit];
                        NSLog(@"success to delete db table data");
                    }else
                    {
                        NSLog(@"error when delete db table data");
                    }
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)deleteDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    listData:(NSArray <NSDictionary *>*)listData
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        [dataBase createDateBaseTable];
        [dataQueue inDatabase:^(FMDatabase * db) {
            if ([db open]) {
                [db beginTransaction];
                for (NSDictionary * userInfo in listData) {
                    NSString *userId = userInfo[primaryId];
                    if (userId) {
                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                        NSString * v5TableSql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",tableName ?:@"",primaryId?:@"",userId ?: @""];
                        BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                        if (res) {
                            NSLog(@"insert or replace into success");
                        }
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
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <NSDictionary *>*)listData
                 completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        [dataBase createDateBaseTable];
        [dataQueue inDatabase:^(FMDatabase * db) {
            if ([db open]) {
                [db beginTransaction];
                for (NSDictionary * userInfo in listData) {
                    NSString *userId = userInfo[primaryId];
                    if (userId) {
                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                        NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into '%@' (data,'%@') values (?,?)",tableName ?:@"",primaryId?:@""];
                        BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                        if (res) {
                            NSLog(@"insert or replace into success");
                        }
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
+ (void)getDatasFromDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                  completion:(void(^)(NSArray <NSDictionary *>*listData))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        [dataBase createDateBaseTable];
        [dataQueue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from '%@' order by '%@'",tableName ?:@"",primaryId ?:@""];
                FMResultSet * rs = [db executeQuery:sql];
                NSData * data;
                NSMutableArray * array = [[NSMutableArray alloc]init];
                while ([rs next])
                {
                    data = [rs dataForColumn:@"data"];
                    [array addObject:[BaseDataQueue unarchiveForData:data]];
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?:completion(array);
                });
            }
        }];
    });
}

+ (void)getDatasFromDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                primaryValue:(NSString *)primaryValue
                  completion:(void(^)(NSDictionary *dictionary))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        dataBase.primaryId = primaryId;
        dataBase.tableName = tableName;
        [dataBase createDateBaseTable];
        [dataQueue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from %@ where %@ = %@",tableName ?:@"",primaryId ?:@"",primaryValue ?:@""];
                FMResultSet * rs = [db executeQuery:sql];
                NSData * data;
                NSMutableArray * array = [[NSMutableArray alloc]init];
                while ([rs next])
                {
                    data = [rs dataForColumn:@"data"];
                    [array addObject:[BaseDataQueue unarchiveForData:data]];
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?:completion(array.firstObject);
                });
            }
        }];
    });
}
+ (void)dropTableDataBase:(NSString *)tableName
               completion:(void (^)(BOOL))completion
{
    FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sqlstr = [NSString stringWithFormat:@"drop table '%@'",tableName?:@""];
            BOOL res =  [db executeUpdate:sqlstr];
            if (res) {
                NSLog(@"drop table successful");
            }else
            {
                NSLog(@"drop table fail");
            }
            [db close];
            !completion ?: completion(res);
        }
    }];
}
+ (NSData *)archivedDataForData:(NSDictionary *)data
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
#pragma mark 属性
- (FMDatabaseQueue *)dataQueue
{
    if (!_dataQueue) {
        NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        //        NSString *stringPath =[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.todayClock"] absoluteString];
        NSString * path = [stringPath stringByAppendingPathComponent:@"DataBase.sqlite"];
        _dataQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _dataQueue;
}
@end
