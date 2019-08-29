//
//  GKNovelDown.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNovelDown.h"
#import "GKDownDataQueue.h"
#import "GKBookCacheDataQueue.h"
@interface GKNovelDown ()
@property (strong, nonatomic) GKDownBookInfo *downInfo;//当前正在下载的小数
@end

@implementation GKNovelDown
- (instancetype)init{
    if (self = [super init]) {
        self.downTasks = @[].mutableCopy;
        [GKDownDataQueue getDatasUnFinish:^(NSArray<GKDownBookInfo *> * _Nonnull listData) {
            if (listData.count > 0) {
                [self->_downTasks addObjectsFromArray:listData];
            }
        }];
    }return self;
}
+ (instancetype )shareInstance
{
    static GKNovelDown *dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
- (GKDownBookInfo *)downInfo{
    if (!_downInfo) {
        GKDownBookInfo *info = [GKNovelDown getInfo:GKDownTaskLoading];
        if (!info) {
            info = [GKNovelDown getInfo:GKDownTaskDefault];
        }
        _downInfo = info;
    }
    return _downInfo;
}
+ (GKDownBookInfo *)getInfo:(GKDownTaskState )state{
    __block GKDownBookInfo *info = nil;
    NSArray *datas = [GKNovelDown shareInstance].downTasks;
    [datas enumerateObjectsUsingBlock:^(GKDownBookInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == state) {
            info = obj;
            *stop = YES;
        }
    }];
    return info;
}
+ (BOOL)haveBookInfo:(GKDownBookInfo *)bookInfo{
    GKNovelDown *down = [GKNovelDown shareInstance];
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"bookId CONTAINS %@",bookInfo.bookId];
    NSArray *array  = [down.downTasks filteredArrayUsingPredicate:pre1];
    return array.count > 0;
}
+ (void)addDownTask:(GKBookDetailModel *)model chapters:(NSArray *)chapters{
    if (!model) {
        return;
    }
    [GKDownDataQueue getDataFromDataBase:model.bookId completion:^(GKDownBookInfo * _Nonnull bookInfo) {
        if (!bookInfo) {//开始下载
            [MBProgressHUD showMessage:@"成功加入下载队列中"];
            GKNovelDown *down = [GKNovelDown shareInstance];
            GKDownBookInfo *info = nil;
            if (down.downInfo) {
                info = [GKDownBookInfo vcWithModel:model chapters:chapters state:GKDownTaskDefault];
                if (![GKNovelDown haveBookInfo:info]) {
                    [down.downTasks addObject:info];
                }
            }else{
                info = [GKDownBookInfo vcWithModel:model chapters:chapters state:GKDownTaskLoading];
                if (![GKNovelDown haveBookInfo:info]) {
                    [down.downTasks insertObject:info atIndex:0];
                }
                [GKNovelDown startDown];
            }
            [GKNovelDown insertDataToDataBase:info];
        }else if (bookInfo.state == GKDownTaskFinish) {
            [MBProgressHUD showMessage:@"该小说已经下载过了"];
        }else if (bookInfo.state == GKDownTaskLoading){
            [MBProgressHUD showMessage:@"该小说正在下载中"];
        }else if (bookInfo.state == GKDownTaskDefault){
            [MBProgressHUD showMessage:@"该小说正等待下载"];
        }else if (bookInfo.state == GKDownTaskPause){
            GKNovelDown *down = [GKNovelDown shareInstance];
            if (!down.downInfo) {
                GKDownBookInfo *info = [GKDownBookInfo vcWithModel:model chapters:chapters state:GKDownTaskLoading];
                [GKNovelDown start:info];
                [MBProgressHUD showMessage:@"成功加入下载队列中"];
            }else{
                [MBProgressHUD showMessage:@"该小说正等待下载"];
            }
        }
    }];
}
+ (void)startDown{
    GKDownBookInfo *info = [GKNovelDown shareInstance].downInfo;
    
    if (info) {
        [GKNovelDown start:info];
    }
}
+ (void)deletes:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    if (bookInfo.state == GKDownTaskLoading) {
        [GKNovelDown pause:bookInfo];
    }
    NSMutableArray *datas = [GKNovelDown shareInstance].downTasks;
    if ([GKNovelDown haveBookInfo:bookInfo]) {
        [datas removeObject:bookInfo];
    }
    [GKDownDataQueue deleteDataToDataBase:bookInfo.bookId completion:^(BOOL success) {
        
    }];
    [GKBookCacheDataQueue dropTableFromDataBase:bookInfo.bookId completion:^(BOOL success) {
        
    }];
    
}
+ (void)wait:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    bookInfo.state = GKDownTaskDefault;
    [GKNovelDown insertDataToDataBase:bookInfo];
}
+ (void)start:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    GKNovelDown *down = [GKNovelDown shareInstance];
    if (![GKNovelDown haveBookInfo:bookInfo]) {
        [down.downTasks addObject:bookInfo];
    }
    bookInfo.state = GKDownTaskLoading;
    down.downInfo = bookInfo;
    [GKNovelDown insertDataToDataBase:bookInfo];
    [GKNovelDown downData:bookInfo];
}
+ (void)pause:(GKDownBookInfo *)bookInfo{
    if (!bookInfo.bookId) {
        return;
    }
    GKNovelDown *down = [GKNovelDown shareInstance];
    bookInfo.state = GKDownTaskPause;
    if ([bookInfo.bookId isEqualToString:down.downInfo.bookId]) {
        bookInfo.state = GKDownTaskPause;
        [GKNovelDown shareInstance].downInfo = nil;
    }
    [GKNovelDown insertDataToDataBase:bookInfo];
}
+ (void)finish:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    GKNovelDown *down = [GKNovelDown shareInstance];
    bookInfo.state = GKDownTaskFinish;
    [GKNovelDown insertDataToDataBase:bookInfo];
    if ([down.downTasks containsObject:bookInfo]) {
        [down.downTasks removeObject:bookInfo];
    }
    down.downInfo = nil;
}
+ (void)insertDataToDataBase:(GKDownBookInfo *)bookInfo{
    if (!bookInfo.bookId) {
        return;
    }
    [GKDownDataQueue insertDataToDataBase:bookInfo completion:nil];
}
+ (void)downData:(GKDownBookInfo *)bookInfo
{
    GKNovelDown *down = [GKNovelDown shareInstance];
    NSArray *chapters = bookInfo.chapters;
    if (chapters.count == 0) {
        return;
    }
    if (!down.downInfo) {
        return;
    }
    if (bookInfo.state == GKDownTaskPause) {
        return;
    }
    if (chapters.count > bookInfo.downIndex) {
        GKBookChapterModel *chapter = [chapters objectSafeAtIndex:bookInfo.downIndex];
        void(^netManager)(void) = ^{
            bookInfo.downIndex ++;
            down.downInfo.downIndex = bookInfo.downIndex;
            !down.completion ?: down.completion(bookInfo.downIndex,bookInfo.chapters.count,GKDownTaskLoading);
            [GKNovelDown downData:bookInfo];
        };
        [GKNovelNetManager bookContent:chapter.link success:^(id object) {
            if (bookInfo.state == GKDownTaskPause || !down.downInfo) {
                return;
            }
            netManager();
            GKBookContentModel *bookModel = [GKBookContentModel modelWithJSON:object[@"chapter"]];
            [GKBookCacheDataQueue insertDataToDataBase:bookInfo.bookId model:bookModel completion:^(BOOL success) {
                
            }];
        } failure:^(NSString *error) {
            netManager();
        }];
    }else{
        [GKNovelDown finish:bookInfo];
        !down.completion ?: down.completion(bookInfo.downIndex,bookInfo.chapters.count,GKDownTaskFinish);
    }
}
+ (NSArray *)waitDownDatas{
    GKNovelDown *down = [GKNovelDown shareInstance];
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"state = 0"];
    NSArray *array  = [down.downTasks filteredArrayUsingPredicate:pre1];
    return array;
}
@end
