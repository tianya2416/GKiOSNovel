//
//  GKDownViewController.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/19.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownViewController.h"
#import "GKDownDataQueue.h"
#import "GKDownLoadCell.h"
#import "GKDownHeadView.h"
#import "GKDownCell.h"
#import "GKNovelDown.h"
@interface GKDownViewController ()
@property (strong, nonatomic) NSMutableArray *finishDatas;
@property (strong, nonatomic) NSMutableArray *listDatas;
@end

@implementation GKDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    [GKNovelDown shareInstance];
    self.finishDatas = @[].mutableCopy;
    self.listDatas = @[].mutableCopy;
    self.view.backgroundColor = Appxf8f8f8;
    self.tableView.backgroundView.backgroundColor = self.tableView.backgroundColor = Appxf8f8f8;
    [self showNavTitle:@"缓存下载"];
    [self setupEmpty:self.tableView image:nil title:@"暂无数据"];
    [self setupRefresh:self.tableView option:ATRefreshNone];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    self.tableView.tableHeaderView = footView;
}
- (void)refreshData:(NSInteger)page{
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_enter(group);
    [GKDownDataQueue getDatasFinish:^(NSArray<GKDownBookInfo *> * _Nonnull listData) {
        self.finishDatas = listData.mutableCopy;
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [GKDownDataQueue getDatasUnFinish:^(NSArray<GKDownBookInfo *> * _Nonnull listData) {
        self.listDatas = listData.mutableCopy;
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.listDatas.count == 0 && self.finishDatas.count == 0) {
             [self endRefreshFailure];
        }else{
            [self.tableView reloadData];
            [self reStart];
            [self endRefresh:NO];
        }
    });
}
- (void)downCompletion{
    __block NSInteger row = 0;
    __block BOOL res = NO;
    GKNovelDown *down = [GKNovelDown shareInstance];
    [down.downTasks removeAllObjects];
    [self.listDatas enumerateObjectsUsingBlock:^(GKDownBookInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [down.downTasks addObject:obj];
    }];
    GKDownBookInfo *downInfo =  down.downInfo;
    if (!downInfo) {
        return;
    }
    [down.downTasks enumerateObjectsUsingBlock:^(GKDownBookInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([downInfo.bookId isEqualToString:obj.bookId]) {
            row = idx;
            res = YES;
        }
    }];
    if (res) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        __block GKDownLoadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        GKDownBookInfo *model = cell.info;
        [GKNovelDown shareInstance].completion = ^(NSInteger index, NSInteger total, GKDownTaskState state) {
            GKDownLoadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.state != state) {
                cell.state = state;
            }
            cell.progress = index;
            if (state == GKDownTaskFinish) {
                model.state = GKDownTaskFinish;
                if (![self.finishDatas containsObject:model]) {
                    [self.finishDatas addObject:model];
                }
                if ([self.listDatas containsObject:model]) {
                    [self.listDatas removeObject:model];
                }
                [self.tableView reloadData];
                [self reStart];
            }
        };
    }
    
}
- (void)reStart{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downCompletion];
        [self startDown];
    });
}
- (void)startDown{
    GKDownBookInfo *info = [GKNovelDown shareInstance].downInfo;
    if (info.state != GKDownTaskLoading) {
        [GKNovelDown startDown];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 1 ? self.finishDatas.count : self.listDatas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ?(self.finishDatas.count ? 30: 0.001):(self.listDatas.count ? 30 : 0.001);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GKDownHeadView *view = [GKDownHeadView instanceView];
    view.titleLab.text = section == 1 ?@"已下载":@"下载中";
    view.hidden = section == 1? (self.finishDatas.count == 0):(self.listDatas.count == 0);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GKDownLoadCell *cell = [GKDownLoadCell cellForTableView:tableView indexPath:indexPath];
        cell.info = self.listDatas[indexPath.row];
        @weakify(cell)
        [cell.downBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(cell)
            if (cell.info.state == GKDownTaskDefault) {//等待
                [self pause:indexPath];
            }else if (cell.info.state == GKDownTaskPause){//暂停
                [self start:indexPath];
            }else if (cell.info.state == GKDownTaskLoading){//下载中
                [self pause:indexPath];
                //如果有等待中 则等待中需要马上下载
                if ([GKNovelDown waitDownDatas].count > 0) {
                    [self reStart];
                }
            }
        }];
        return cell;
    }
    GKDownCell *cell =[GKDownCell cellForTableView:tableView indexPath:indexPath];
    cell.info = self.finishDatas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        GKBookDetailModel *model = [GKBookDetailModel modelWithJSON:[self.finishDatas[indexPath.row] modelToJSONObject]];
        [GKJumpApp jumpToBookRead:model];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteAction:indexPath];
    }];
    return @[delete];
}
- (void)deleteAction:(NSIndexPath *)indexPath{
    [ATAlertView showTitle:@"删除提示" message:[NSString stringWithFormat:@"\n确定删除该小说,删除后不可还原\n"] normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index == 0) {
            return ;
        }
        NSMutableArray *datas = indexPath.section == 1 ? self.finishDatas : self.listDatas;
        GKDownBookInfo *info = datas[indexPath.row];
        if ([datas containsObject:info]) {
            [datas removeObject:info];
            [self.tableView reloadData];
        }
        [GKNovelDown deletes:info];
    }];
}
#pragma action
- (void)start:(NSIndexPath *)indexPath{
    __block GKDownLoadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    GKDownBookInfo * model = cell.info;
    if (model.state == GKDownTaskLoading) {
        return;
    }
    GKDownBookInfo *info = [GKNovelDown shareInstance].downInfo;
    if (info && ![model.bookId isEqualToString:info.bookId]) {
        cell.state = GKDownTaskDefault;
        [GKNovelDown wait:model];
        [self.tableView reloadData];
        return;
    }
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.state = GKDownTaskLoading;
    [self downCompletion];
    [GKNovelDown start:model];
}

- (void)pause:(NSIndexPath *)indexPath{
    GKDownLoadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    GKDownBookInfo *model = cell.info;
    if (model.state == GKDownTaskPause) {
        return;
    }
    cell.state = GKDownTaskPause;
    [GKNovelDown pause:model];
    [self.tableView reloadData];
}
@end
