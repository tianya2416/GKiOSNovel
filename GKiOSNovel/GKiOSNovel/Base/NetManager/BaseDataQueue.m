//
//  BaseDataQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"
static NSString * DataBase = @"DataBase.sqlite";//数据库名称
@interface BaseDataQueue()
@property(strong, nonatomic)FMDatabaseQueue *dataQueue;
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
+ (void)tableExists:(FMDatabase *)dataBase
          tableName:(NSString *)tableName
          primaryId:(NSString *)primaryId{
    if (![dataBase tableExists:tableName]) {
        if ([dataBase open]) {
            //数据库建表
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (data text,'%@' varchar primary key)",tableName,primaryId];
            if ([dataBase executeUpdate:sql]) {
                NSLog(@"create table success");
            }
            [dataBase close];
        }
    }
}
+ (void)insertDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        NSString *userId = userInfo[primaryId];
        assert(userId);
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase * db) {
                [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    NSString * sql = [NSString stringWithFormat:@"insert or replace into '%@' (data,'%@') values (?,?)",tableName ?: @"",primaryId ?: @""];
                    BOOL res = [db executeUpdate:sql withArgumentsInArray:@[data,userId]];
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
+ (void)insertDatasDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
                   listData:(NSArray <NSDictionary *>*)listData
                 completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
            if ([db open]) {
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    [listData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull userInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *userId = userInfo[primaryId];
                        assert(userId);
                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                        NSString *sql = [NSString stringWithFormat:@"insert or replace into '%@' (data,'%@') values (?,?)",tableName ?:@"",primaryId?:@""];
                        BOOL res = [db executeUpdate:sql withArgumentsInArray:@[data,userId]];
                        if (res) {
                            NSLog(@"insert or replace into success");
                        }
                    }];
                }
                @catch (NSException *exception) {
                    NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
                    isRollBack = YES;
                    [db rollback];
                }
                @finally {
                    BOOL success = [db commit];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(success);
                    });
                    [db close];
                }
//                for (NSDictionary * userInfo in listData) {
//                    NSString *userId = userInfo[primaryId];
//                    assert(userId);
//                    if (userId) {
//                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
//                        NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into '%@' (data,'%@') values (?,?)",tableName ?:@"",primaryId?:@""];
//                        BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
//                        if (res) {
//                            NSLog(@"insert or replace into success");
//                        }
//                    }
//                }
//                BOOL success = [db commit];
//                [db close];
            }
        }];
    });
}
+ (void)updateDataToDataBase:(NSString *)tableName
                   primaryId:(NSString *)primaryId
                    userInfo:(NSDictionary *)userInfo
                  completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        NSString *userId = userInfo[primaryId];
        assert(userId);
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase * db) {
                [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    // NSString * v5TableSql = [NSString stringWithFormat:@"replace into '%@' (data,'%@') values (?,?)",tableName ?: @"",primaryId ?: @""];
                    NSString * sql = [NSString stringWithFormat:@"update %@ set data = ? where %@ = '%@'",tableName?:@"",primaryId?:@"",userId?:@""];
                    BOOL res = [db executeUpdate:sql withArgumentsInArray:@[data]];
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
        NSString *userId = primaryValue ?:@"";
        assert(userId);
        if (userId) {
            [dataQueue inDatabase:^(FMDatabase *db) {
                 [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
                if ([db open]) {
                    [db beginTransaction];
                    NSString * sql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",tableName,primaryId,userId ?: @""];
                    BOOL res = [db executeUpdate:sql];
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
+ (void)deleteDatasToDataBase:(NSString *)tableName
                    primaryId:(NSString *)primaryId
                     listData:(NSArray <NSDictionary *>*)listData
                   completion:(void(^)(BOOL success))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
            if ([db open]) {
                [db beginTransaction];
                for (NSDictionary * userInfo in listData) {
                    NSString *userId = userInfo[primaryId];
                    if (userId) {
                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                        NSString * sql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",tableName ?:@"",primaryId?:@"",userId ?: @""];
                        BOOL res = [db executeUpdate:sql withArgumentsInArray:@[data,userId]];
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
        [dataQueue inDatabase:^(FMDatabase *db) {
            [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
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
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  completion:(void(^)(NSArray <NSDictionary *>*listData))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase *db) {
            [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from '%@' order by '%@' limit %@,%@",tableName ?:@"",primaryId ?:@"",@((page-1)*pageSize),@(pageSize)];
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
+ (void)getDataFromDataBase:(NSString *)tableName
                  primaryId:(NSString *)primaryId
               primaryValue:(NSString *)primaryValue
                 completion:(void(^)(NSDictionary *dictionary))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BaseDataQueue *dataBase = [BaseDataQueue shareInstance];
        FMDatabaseQueue *dataQueue = dataBase.dataQueue;
        [dataQueue inDatabase:^(FMDatabase *db) {
            [BaseDataQueue tableExists:db tableName:tableName primaryId:primaryId];
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from '%@' where %@ ='%@'",tableName ?:@"",primaryId ?:@"",primaryValue ?:@""];
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
            NSString * sqlstr = [NSString stringWithFormat:@"drop table if exists '%@'",tableName?:@""];
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
        NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Caches/Sqlite"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        //NSString *stringPath =[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.todayClock"] absoluteString];
        NSString * path = [stringPath stringByAppendingPathComponent:DataBase];
        _dataQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _dataQueue;
}
@end
