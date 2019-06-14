//
//  GKMineController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMineController.h"
#import "GKMineRankController.h"
#import "GKStartViewController.h"
#import "GKMineCell.h"
static NSString *rank = @"排行榜";
static NSString *sex = @"性别";
@interface GKMineController ()
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [self reloadUI];
    [self endRefresh:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadUI];
}
- (void)reloadUI{
    GKUserState state = [GKUserManager shareInstance].user.state;
    self.listData = @[@{@"title":rank,@"subTitle":@""},@{@"title":sex,@"subTitle":(state == GKUserBoy ?@"小哥哥":@"小姐姐")}];
    [self.tableView reloadData];
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
    GKMineCell *cell = [GKMineCell cellForTableView:tableView indexPath:indexPath];
    NSDictionary *dic = self.listData[indexPath.row];
    cell.titlaLab.text = dic[@"title"]?:@"";
    cell.subTitleLab.text = dic[@"subTitle"]?:@"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dic = self.listData[indexPath.row];
    NSString *title = dic[@"title"];
    if ([title isEqualToString:rank]) {
        GKMineRankController *vc = [[GKMineRankController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:sex]){
        GKStartViewController *vc = [[GKStartViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
