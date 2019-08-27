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
@property (strong, nonatomic) NSMutableArray *downTasks;//数组中要下载的小说
@property (assign, nonatomic) NSInteger downIndex;//当前小说下载到第几章节
@property (assign, nonatomic) BOOL pause;//当前是否暂停
@property (assign, nonatomic) BOOL delete;//当前是否删除
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
+ (void)addDownTask:(GKBookDetailModel *)bookInfo chapters:(NSArray <GKBookChapterModel *>*)chapters{
    if (!bookInfo) {
        return;
    }
    [GKDownDataQueue getDataFromDataBase:bookInfo.bookId completion:^(GKDownBookInfo * _Nonnull model) {
        if (!model) {//开始下载
            [MBProgressHUD showMessage:@"成功加入下载队列中"];
            GKNovelDown *down = [GKNovelDown shareInstance];
            GKDownBookInfo *info = nil;
            if (down.downInfo) {
                info = [GKDownBookInfo vcWithModel:bookInfo chapters:chapters state:GKDownTaskDefault];
                [down.downTasks addObject:info];
            }else{
                info = [GKDownBookInfo vcWithModel:bookInfo chapters:chapters state:GKDownTaskLoading];
                [down.downTasks insertObject:info atIndex:0];
                [GKNovelDown startDown];
            }
            [GKNovelDown insertDataToDataBase:info];
        }else if (model.state == GKDownTaskFinish) {
            [MBProgressHUD showMessage:@"该小说已经下载过了"];
        }else if (model.state == GKDownTaskLoading){
            [MBProgressHUD showMessage:@"该小说正在下载中"];
        }else if (model.state == GKDownTaskDefault){
            [MBProgressHUD showMessage:@"该小说正等待下载"];
        }else if (model.state == GKDownTaskPause){
            GKNovelDown *down = [GKNovelDown shareInstance];
            if (!down.downInfo) {
                GKDownBookInfo *info = [GKDownBookInfo vcWithModel:bookInfo chapters:chapters state:GKDownTaskLoading];
                [GKNovelDown start:info completion:nil];
                [MBProgressHUD showMessage:@"成功加入下载队列中"];
            }else{
                [MBProgressHUD showMessage:@"该小说正等待下载"];
            }
        }
    }];
}
+ (void)startDown{
    __block GKDownBookInfo *info = nil;
    NSArray *datas = [GKNovelDown shareInstance].downTasks;
    [datas enumerateObjectsUsingBlock:^(GKDownBookInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == GKDownTaskLoading) {
            info = obj;
            *stop = YES;
        }else if (obj.state == GKDownTaskDefault){
            info = obj;
            *stop = YES;
        }
    }];
    if (info) {
        [GKNovelDown start:info completion:nil];
    }
}
+ (void)deletes:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    if (bookInfo.state == GKDownTaskLoading) {
        [GKNovelDown pause:bookInfo delete:YES];
    }
    NSMutableArray *datas = [GKNovelDown shareInstance].downTasks;
    if ([datas containsObject:bookInfo]) {
        [datas removeObject:bookInfo];
    }
    [GKDownDataQueue deleteDataToDataBase:bookInfo.bookId completion:^(BOOL success) {
        
    }];
    [GKBookCacheDataQueue dropTableFromDataBase:bookInfo.bookId completion:^(BOOL success) {
        
    }];
}
+ (void)start:(GKDownBookInfo *)bookInfo completion:(void(^)(NSInteger index,NSInteger total,GKDownTaskState state))completion{
    if (!bookInfo) {
        return;
    }
    bookInfo.state = GKDownTaskLoading;
    [GKNovelDown shareInstance].downInfo = bookInfo;
    [GKNovelDown shareInstance].downIndex = bookInfo.downIndex;
    [GKNovelDown shareInstance].pause = NO;
    [GKNovelDown insertDataToDataBase:bookInfo];
    [GKNovelDown downData:bookInfo completion:completion];
}
+ (void)pause:(GKDownBookInfo *)bookInfo{
    [GKNovelDown pause:bookInfo delete:NO];
}
+ (void)pause:(GKDownBookInfo *)bookInfo delete:(BOOL)delete{
    if (!bookInfo) {
        return;
    }
    bookInfo.state = GKDownTaskPause;
    [GKNovelDown shareInstance].downInfo = nil;
    [GKNovelDown shareInstance].pause = YES;
    [GKNovelDown shareInstance].delete = delete;
    [GKNovelDown insertDataToDataBase:bookInfo];
}
+ (void)finish:(GKDownBookInfo *)bookInfo{
    if (!bookInfo) {
        return;
    }
    bookInfo.state = GKDownTaskFinish;
    [GKNovelDown insertDataToDataBase:bookInfo];
    [[GKNovelDown shareInstance].downTasks removeObject:bookInfo];
    [GKNovelDown shareInstance].downInfo = nil;
}
+ (void)insertDataToDataBase:(GKDownBookInfo *)bookInfo{
    if (!bookInfo.bookId) {
        return;
    }
    [GKDownDataQueue insertDataToDataBase:bookInfo completion:nil];
}
+ (void)downData:(GKDownBookInfo *)bookInfo completion:(void(^)(NSInteger index,NSInteger total,GKDownTaskState state))completion{
    NSArray *chapters = bookInfo.chapters;
    if (chapters.count == 0) {
        return;
    }
    if ([GKNovelDown shareInstance].delete) {
        return;
    }
    if ([GKNovelDown shareInstance].pause) {
        [GKNovelDown pause:bookInfo];
        !completion ?: completion(bookInfo.downIndex,bookInfo.chapters.count,GKDownTaskPause);
        return;
    }
    if (chapters.count > [GKNovelDown shareInstance].downIndex) {
        GKBookChapterModel *chapter = [chapters objectSafeAtIndex:[GKNovelDown shareInstance].downIndex];
        void(^netManager)(void) = ^{
            [GKNovelDown shareInstance].downIndex ++;
            bookInfo.downIndex = [GKNovelDown shareInstance].downIndex;
            !completion ?: completion(bookInfo.downIndex,bookInfo.chapters.count,GKDownTaskLoading);
            [GKNovelDown downData:bookInfo completion:completion];

        };
        
        [GKBookCacheDataQueue getDataFromDataBase:bookInfo.bookId chapterId:chapter.chapterId completion:^(GKBookContentModel * _Nonnull bookModel) {
            if (bookModel) {
                netManager();
            }else{
                [GKNovelNetManager bookContent:chapter.link success:^(id object) {
                    netManager();
                    GKBookContentModel *bookModel = [GKBookContentModel modelWithJSON:object[@"chapter"]];
                    [GKBookCacheDataQueue insertDataToDataBase:bookInfo.bookId model:bookModel completion:^(BOOL success) {
                        
                    }];
                } failure:^(NSString *error) {
                    netManager();
                }];
            }
        }];
    }else{
        [GKNovelDown finish:bookInfo];
        if (completion) {
            !completion ?: completion(bookInfo.downIndex,bookInfo.chapters.count,GKDownTaskFinish);
        }else{
            [GKNovelDown startDown];
        }
    }
}
@end
