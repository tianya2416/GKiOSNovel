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
#import "GKDownViewController.h"
#import "GKMineModel.h"
static NSString *down = @"我的下载";
static NSString *bookCase = @"我的书架";
static NSString *readHistory = @"浏览记录";
static NSString *rank = @"我的首页";
static NSString *sex = @"我的性别";
static NSString *theme = @"我的主题";
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
    
    GKMineModel *model1 = [GKMineModel vcWithTitle:down subTitle:@"" iCon:@"icon_down"];
    GKMineModel *model2 = [GKMineModel vcWithTitle:bookCase subTitle:@"" iCon:@"icon_fav"];
    GKMineModel *model3 = [GKMineModel vcWithTitle:readHistory subTitle:@"" iCon:@"icon_historys"];
    
    GKMineModel *model4 = [GKMineModel vcWithTitle:rank subTitle:@"" iCon:@"icon_option"];
    GKMineModel *model5 = [GKMineModel vcWithTitle:sex subTitle:(state == GKUserBoy ?@"小哥哥":@"小姐姐") iCon:@"icon_safe"];
    GKMineModel *model6 = [GKMineModel vcWithTitle:theme subTitle:model.title?:@"" iCon:@"icon_set"];
    self.listData = @[model1,model2,model3,model4,model5,model6];
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
    GKMineModel *model = self.listData[indexPath.row];
    cell.titlaLab.text = model.title ?:@"";
    cell.subTitleLab.text = model.subTitle ?:@"";
    cell.iConImageV.image = [UIImage imageNamed:model.iCon];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     GKMineModel *model = self.listData[indexPath.row];
    NSString *title = model.title;
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
    }else if([title isEqualToString:down]){
        vc = [[GKDownViewController alloc] init];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
