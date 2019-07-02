//
//  GKThemeViewController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKThemeViewController.h"
#import "GKThemeCell.h"
#import "GKNovelTabBarController.h"
@interface GKThemeViewController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"主题切换"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];

}
- (void)refreshData:(NSInteger)page{
    self.listData = @[].mutableCopy;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"App" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        GKAppModel *model = [GKAppModel modelWithJSON:obj];
        [self.listData addObject:model];
    }];
    [self.tableView reloadData];
    NSLog(@"%@",dic);
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
    GKThemeCell *cell = [GKThemeCell cellForTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKAppModel *modelq = [GKAppTheme shareInstance].model;
    GKAppModel *model = self.listData[indexPath.row];
    if ([modelq.title isEqualToString:model.title]) {
        return;
    }
    [ATAlertView showTitle:@"提示" message:@"切换主题会重新启动程序" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [GKAppTheme saveAppTheme:model];
            [GKJumpApp jumpToAppGuidePage:^{
                [GKJumpApp jumpToAppTheme];
            }];
        }
    }];
}
@end
