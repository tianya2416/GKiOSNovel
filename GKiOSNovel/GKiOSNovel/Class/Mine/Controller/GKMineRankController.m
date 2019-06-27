//
//  GKMineRankController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMineRankController.h"
#import "GKMineSelectController.h"
#import "GKMineCell.h"
@interface GKMineRankController ()
@property (strong, nonatomic) NSMutableArray <GKRankModel *>*listData;
@end

@implementation GKMineRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"自定义首页"];
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_nav_add"] action:@selector(addAction)];
    [self setupEmpty:self.tableView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请点击右上角进行添加"];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self headerRefreshing];
}
- (void)refreshData:(NSInteger)page{
    self.listData = [GKUserManager shareInstance].user.rankDatas.mutableCopy;
    [self.tableView reloadData];
    [self endRefresh:NO];
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
    GKRankModel *model = self.listData[indexPath.row];
    cell.titlaLab.text = model.shortTitle ?:@"";
    cell.subTitleLab.text = @"";
    cell.imageV.hidden = YES;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAction:self.listData[indexPath.row]];
    }
}
- (void)deleteAction:(GKRankModel *)model{
    [ATAlertView showTitle:[NSString stringWithFormat:@"删除<%@>后,首页将失去该项",model.shortTitle] message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [self.listData removeObject:model];
            GKUserModel *model = [GKUserModel vcWithState:[GKUserManager shareInstance].user.state rankDatas:self.listData.copy];
            [GKUserManager saveUserModel:model];
            [GKUserManager reloadHomeData:GKLoadDataDefault];
            [self refreshData:1];
            
        }
    }];
}
- (void)addAction{
   [GKJumpApp jumpToAddSelect];
}
@end
