//
//  GKBookListDetailController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookListDetailController.h"
#import "GKBookListDetailModel.h"
#import "GKShareViewController.h"
#import "GKBookDetailView.h"
#import "GKClassflyCell.h"
@interface GKBookListDetailController ()
@property (strong, nonatomic) GKBookDetailView *detailView;
@property (strong, nonatomic) GKBookListDetailModel *model;
@property (copy, nonatomic) NSString *bookId;
@end

@implementation GKBookListDetailController
+ (instancetype)vcWithBookId:(NSString *)bookId{
    GKBookListDetailController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"书单详情"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareAction)];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager bookListDetail:self.bookId success:^(id  _Nonnull object) {
        self.model = [GKBookListDetailModel modelWithJSON:object[@"bookList"]];
        self.detailView.model = self.model;
        CGFloat height = [self.detailView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [self.detailView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        self.tableView.tableHeaderView = self.detailView;
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }] ;
}
- (void)shareAction{
    [self presentPanModal:[GKShareViewController vcWithBookListModel:self.model]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.books.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKClassflyCell *cell = [GKClassflyCell cellForTableView:tableView indexPath:indexPath];
    GKBooksModel*model = self.model.books[indexPath.row];
    cell.model = model.book;
    cell.subTitleLab.text = model.comment ?:@"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKBooksModel*model = self.model.books[indexPath.row];
    [GKJumpApp jumpToBookDetail:model.book._id];
}
- (GKBookDetailView *)detailView{
    if (!_detailView) {
        _detailView = [GKBookDetailView instanceView];
    }
    return _detailView;
}

@end
