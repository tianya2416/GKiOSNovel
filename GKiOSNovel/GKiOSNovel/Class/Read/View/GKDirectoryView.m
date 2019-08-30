//
//  GKDirectoryView.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/9.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDirectoryView.h"
#import "GKDirectoryCell.h"
@implementation GKDirectoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }return self;
}
- (void)loadUI{
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    self.backgroundColor = Appxffffff;
    [self addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview).offset(STATUS_BAR_HIGHT);
    }];
}
- (void)setListData:(NSArray *)listData{
    _listData = listData;
    [self.tableView reloadData];
}
- (void)show{
    NSInteger index = [self.listData indexOfObject:self.model];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //滚动到其相应的位置
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALEW(55);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKDirectoryCell *cell = [GKDirectoryCell cellForTableView:tableView indexPath:indexPath];
    GKBookChapterModel *chapter = self.listData[indexPath.row];
    cell.iconV.hidden =  !chapter.isVip;
    cell.titleLab.text = chapter.title ?:@"";
    cell.select = (chapter == self.model);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(directoryView:chapter:)]) {
        [self.delegate directoryView:self chapter:indexPath.row];
    }
}
@end
