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
#import "GKBooCaseController.h"
#import "GKBookHistoryController.h"
#import "GKThemeViewController.h"
#import "GKMineSelectController.h"
#import "GKMineCell.h"
static NSString *rank = @"自定义首页";
static NSString *sex = @"性别";
static NSString *bookCase = @"我的书架";
static NSString *readHistory = @"读书记录";
static NSString *theme = @"主题";
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
    GKAppModel *model = [GKAppTheme shareInstance].model;
    GKUserState state = [GKUserManager shareInstance].user.state;
    self.listData = @[@{@"title":rank,@"subTitle":@""},@{@"title":readHistory?:@"",@"subTitle":@""},@{@"title":bookCase?:@"",@"subTitle":@""},@{@"title":sex,@"subTitle":(state == GKUserBoy ?@"小哥哥":@"小姐姐")},@{@"title":theme?:@"",@"subTitle":model.title?:@""}];
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
    UIViewController *vc = nil;
    if ([title isEqualToString:rank]) {
        vc = [[GKMineSelectController alloc] init];
    }else if ([title isEqualToString:sex]){
        vc = [[GKStartViewController alloc] init];
    }else if([title isEqualToString:bookCase]){
        vc = [[GKBooCaseController alloc] init];
    }else if ([title isEqualToString:readHistory]){
        vc = [[GKBookHistoryController alloc] init];
    }else if ([title isEqualToString:theme]){
        vc = [[GKThemeViewController alloc] init];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
