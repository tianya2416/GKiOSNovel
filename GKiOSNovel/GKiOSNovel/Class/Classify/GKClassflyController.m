//
//  GKClassflyController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKClassflyController.h"
#import "GKClassItemModel.h"
#import "GKBookModel.h"
#import "GKClassflyCell.h"
@interface GKClassflyController ()
@property (copy, nonatomic) NSString *group;
@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKClassflyController
+ (instancetype)vcWithGroup:(NSString *)group name:(NSString *)name{
    GKClassflyController *vc =[[[self class] alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.group = group;
    vc.name = name;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:self.name];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager homeClssItem:self.group major:self.name page:page success:^(id  _Nonnull object) {
         GKBookInfo *info = [GKBookInfo modelWithJSON:object];
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
            [self showNavTitle:[NSString stringWithFormat:@"%@(%@)",self.name,@(info.total)]];
        }
        info.books.count ? [self.listData addObjectsFromArray:info.books] : nil;
        [self.tableView reloadData];
        [self endRefresh:info.books.count >= RefreshPageSize];
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
