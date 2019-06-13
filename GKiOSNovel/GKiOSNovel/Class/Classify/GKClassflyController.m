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
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        NSArray *datas = [NSArray modelArrayWithClass:GKBookModel.class json:object[@"books"]];
        datas.count ? [self.listData addObjectsFromArray:datas] : nil;
        [self.tableView reloadData];
        [self endRefresh:datas.count >= RefreshPageSize];
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
@end
