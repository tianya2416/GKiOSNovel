//
//  GKBookHistoryController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookHistoryController.h"
#import "GKClassflyCell.h"
@interface GKBookHistoryController ()
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) BOOL needRequesst;
@end

@implementation GKBookHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    self.needRequesst = NO;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needRequesst) {
        [self headerRefreshing];
    }
    self.needRequesst = YES;
}
- (void)loadUI{
    [self showNavTitle:@"读书记录"];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.tableView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请到书籍详情页观看你喜欢的书籍吧"];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}
- (void)loadData{
    
}
- (void)refreshData:(NSInteger)page{
    [GKBookReadDataQueue getDatasFromDataBase:page pageSize:RefreshPageSize completion:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        if (listData) {
            [self.listData addObjectsFromArray:listData];
        }
        [self.tableView reloadData];
        self.listData.count == 0  ? [self endRefreshFailure] : [self endRefresh:listData.count >= RefreshPageSize];
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
    GKBookReadModel*model = self.listData[indexPath.row];
    cell.model = model.bookModel;
    cell.subTitleLab.text = [self subTitle:model];
    return cell;
}
- (NSString *)subTitle:(GKBookReadModel *)model{
    NSString *title = [NSString stringWithFormat:@"最近阅读: %@\n\r%@",model.bookChapter.title,model.bookContent.content];
    return title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKBookReadModel*model = self.listData[indexPath.row];
    [GKJumpApp jumpToBookRead:model.bookModel];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置返回存放侧滑按钮数组
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //这是iOS8以后的方法

    GKBookReadModel*model = self.listData[indexPath.row];
    UITableViewRowAction *deleBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteAction:model];
    }];
    UITableViewRowAction *topBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self topAction:model];
    }];
   // deleBtn.backgroundColor = [UIColor colorWithRGB:0x71d321];
    topBtn.backgroundColor = AppColor;
    return @[topBtn,deleBtn];
    
}
- (void)topAction:(GKBookReadModel *)model{
    model.updateTime = @"";
    [GKBookReadDataQueue updateDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self headerRefreshing];
        }
    }];
}
- (void)deleteAction:(GKBookReadModel *)model{
    [ATAlertView showTitle:[NSString stringWithFormat:@"确定将%@从历史记录删除吗？",model.bookModel.title] message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [self.listData removeObject:model];
            [GKBookReadDataQueue deleteDataToDataBase:model.bookId completion:^(BOOL success) {
                [self.tableView reloadData];
            }];
            
        }
    }];
}

@end
