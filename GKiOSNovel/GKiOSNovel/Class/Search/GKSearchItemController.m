//
//  GKSearchItemController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchItemController.h"
#import "GKClassflyCell.h"
@interface GKSearchItemController ()
@property (copy, nonatomic) NSString *hotWord;
@property (strong, nonatomic) GKBookInfo *bookInfo;
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKSearchItemController
+ (instancetype)vcWithHotWord:(NSString *)hotWord{
    GKSearchItemController *vc = [[[self class] alloc] init];
    vc.hotWord = hotWord;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData = @[].mutableCopy;
    [self showNavTitle:self.hotWord];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager homeSearch:self.hotWord page:page success:^(id  _Nonnull object) {
        self.bookInfo = [GKBookInfo modelWithJSON:object];
        [self showNavTitle:[NSString stringWithFormat:@"%@(%@)",self.hotWord,@(self.bookInfo.total)]];
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        self.bookInfo.books ? [self.listData addObjectsFromArray:self.bookInfo.books] : nil;
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
    GKClassflyCell *cell = [GKClassflyCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKBookModel *model =  self.listData[indexPath.row];
    [GKJumpApp jumpToBookDetail:model._id];
    
}

@end
