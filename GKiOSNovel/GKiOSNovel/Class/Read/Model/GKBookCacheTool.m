//
//  GKBookCacheTool.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/3.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookCacheTool.h"
#import "GKBookCacheDataQueue.h"
@interface GKBookCacheTool()
@property (strong, nonatomic) NSArray*currentData;
@property (strong, nonatomic) NSMutableArray *chapters;


@property (strong, nonatomic) NSMutableArray *success;
@property (strong, nonatomic) NSMutableArray *failure;
@property (copy, nonatomic) void (^progress)(NSInteger index,NSInteger total);
@property (copy, nonatomic) void (^completion)(BOOL finish,NSString* error);

@property (strong, nonatomic) GKBookSourceInfo *bookSource;
@property (strong, nonatomic) GKBookChapterInfo *bookChapter;
@property (strong, nonatomic) GKBookContentModel *bookContent;
@end

@implementation GKBookCacheTool
- (void)dealloc{
    NSLog(@"GKBookCacheTool dealloc");
}
- (void)downloadData:(NSString *)bookId
            progress:(void (^)(NSInteger index,NSInteger total))progress
          completion:(void (^)(BOOL finish,NSString *error))completion{
    self.download = YES;
    self.progress = progress;
    self.completion = completion;
    [self.success removeAllObjects];
    [self.failure removeAllObjects];
    @weakify(self)
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_semaphore_t sem2 = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        @strongify(self)
        [GKNovelNetManager bookSummary:bookId success:^(id  _Nonnull object) {
            @strongify(self)
            self.bookSource.listData = [NSArray modelArrayWithClass:GKBookSourceModel.class json:object];
            dispatch_semaphore_signal(sem);
        } failure:^(NSString *error) {
            
        }];
    });
    dispatch_async(queue, ^{
        @strongify(self)
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        [GKNovelNetManager bookChapters:self.bookSource.bookSourceId success:^(id object) {
            @strongify(self)
            self.bookChapter = [GKBookChapterInfo modelWithJSON:object];
            dispatch_semaphore_signal(sem2);
        } failure:^(NSString *error) {
            
        }];
    });
    dispatch_async(queue, ^{
        @strongify(self)
        dispatch_semaphore_wait(sem2, DISPATCH_TIME_FOREVER);
         self.chapters = self.bookChapter.chapters.mutableCopy;
        [self downloadContent:bookId];
    });
}
- (void)downloadContent:(NSString *)bookId{

    if (self.chapters.count && self.currentData) {
        [self.chapters removeObjectsInArray:self.currentData];
    }
    self.currentData = @[];
    if (self.chapters.count == 0) {
        if (self.failure.count) {
            [self.chapters addObjectsFromArray:self.failure.copy];
        }
        if (self.chapters.count == 0) {
            if (self.success.count == self.bookChapter.chapters.count) {
                self.download = NO;
                !self.completion ?: self.completion(YES,@"");
            }
            return;
        }else{
            [self.failure removeAllObjects];
            [self downloadContent:bookId];
            return;
        }
    }
    NSArray *datas  = self.chapters.count > 20 ? [self.chapters subarrayWithRange:NSMakeRange(0, 20)]: self.chapters.copy;
    [self loadData:datas bookId:bookId];
}
- (void)loadData:(NSArray *)chaptersDatas bookId:(NSString *)bookId{
    @weakify(self)
    self.currentData = chaptersDatas;
    NSInteger count = self.bookChapter.chapters.count;
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    dispatch_group_t group = dispatch_group_create();
    [chaptersDatas enumerateObjectsUsingBlock:^(GKBookChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        dispatch_group_enter(group);
        [GKNovelNetManager bookContent:obj.link success:^(id object) {
            @strongify(self)
            GKBookContentModel *content = [GKBookContentModel modelWithJSON:object[@"chapter"]];
            [datas addObject:content];
            [self.success addObject:content];
            !self.progress ?: self.progress(self.success.count + self.failure.count,count);
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            @strongify(self)
            [self.failure addObject:obj];
            !self.progress ?: self.progress(self.success.count + self.failure.count,count);
            dispatch_group_leave(group);
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self)
        [GKBookCacheDataQueue insertDatasDataBase:bookId listData:datas.copy completion:^(BOOL success) {
            
        }];
        [self downloadContent:bookId];
    });
}
+ (void)bookContent:(NSString *)url
          contentId:(NSString *)contentId
             bookId:(NSString *)bookId
         sameSource:(NSInteger )sameSource
            success:(void(^)(GKBookContentModel *model))success
            failure:(void(^)(NSString *error))failure{
    if (sameSource == 0) {//由于下载只会下载第一个源的文章 所有如果切换到其他源这时候需要重新去网络请求数据
        [GKBookCacheDataQueue getDataFromDataBase:bookId contentId:contentId completion:^(GKBookContentModel * _Nonnull bookModel) {
            if (bookModel.title && bookModel.content) {
                !success ?: success(bookModel);
            }else{
                [GKNovelNetManager bookContent:url success:^(id object) {
                    GKBookContentModel *bookModel = [GKBookContentModel modelWithJSON:object[@"chapter"]];
                    !success ?: success(bookModel);
                } failure:failure];
            }
        }];
    }else{
        [GKNovelNetManager bookContent:url success:^(id object) {
            GKBookContentModel *bookModel = [GKBookContentModel modelWithJSON:object[@"chapter"]];
            !success ?: success(bookModel);
        } failure:failure];
    }
}
#pragma mark
- (GKBookSourceInfo *)bookSource{
    if (!_bookSource) {
        _bookSource = [[GKBookSourceInfo alloc] init];
    }
    return _bookSource;
}
- (NSMutableArray *)success{
    if (!_success) {
        _success = [[NSMutableArray alloc] init];
    }return _success;
}
- (NSMutableArray *)failure{
    if (!_failure) {
        _failure = [[NSMutableArray alloc] init];
    }
    return _failure;
}
@end
