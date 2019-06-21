//
//  GKBookChapterController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookChapterController.h"
#import "GKBookChapterCell.h"
#import "GKStartCell.h"
#import "GKBookChapterModel.h"
@interface GKBookChapterController ()
@property (copy, nonatomic)NSString *bookSourceId;
@property (assign, nonatomic)NSInteger chapterItem;

@property (strong, nonatomic)GKBookChapterInfo *chapterInfo;
@property (copy, nonatomic) void (^completion)(NSInteger selectIndex);
@end

@implementation GKBookChapterController
+ (instancetype)vcWithChapter:(NSString *)bookSourceId chapter:(NSInteger )chapter completion:(void (^)(NSInteger index))completion{
    GKBookChapterController *vc = [[[self class] alloc] init];
    vc.chapterItem = chapter;
    vc.bookSourceId = bookSourceId;
    vc.completion = completion;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    [self showNavTitle:@"章节选择"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager bookChapters:self.bookSourceId success:^(id  _Nonnull object) {
        self.chapterInfo = [GKBookChapterInfo modelWithJSON:object];
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chapterInfo.chapters.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookChapterCell *cell = [GKBookChapterCell cellForTableView:tableView indexPath:indexPath];
    GKBookChapterModel *model = self.chapterInfo.chapters[indexPath.row];
    cell.titleLab.text = model.title ?:@"";
    cell.imageV.hidden = (indexPath.row != self.chapterItem);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !self.completion ?: self.completion(indexPath.row);
    [self goBack];
}
@end
@interface GKBookSourceController()
@property (strong, nonatomic) NSString *bookId;
@property (strong, nonatomic) NSString *sourceId;
@property (strong, nonatomic) NSArray *listData;
@property (copy, nonatomic) void (^completion)(NSInteger selectIndex);
@end

@implementation GKBookSourceController
+ (instancetype)vcWithChapter:(NSString *)bookId sourceId:(NSString *)sourceId completion:(void (^)(NSInteger index))completion{
    GKBookSourceController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    vc.sourceId = sourceId;
    vc.completion = completion;
    return vc;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self showNavTitle:@"源选择"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager bookSummary:self.bookId success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKBookSourceModel.class json:object];
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookChapterCell *cell = [GKBookChapterCell cellForTableView:tableView indexPath:indexPath];
    GKBookSourceModel *model = self.listData[indexPath.row];
    cell.imageV.hidden = ![model._id isEqualToString:self.sourceId];
    cell.titleLab.text = model.name ?:@"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !self.completion ?: self.completion(indexPath.row);
    [self goBack];
}
@end
