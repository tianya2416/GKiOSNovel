//
//  GKHomeMoreController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeMoreController.h"
#import "GKClassflyCell.h"
@interface GKHomeMoreController ()
@property (strong, nonatomic) NSArray *listData;
@property (copy, nonatomic) GKBookInfo *bookInfo;
@end

@implementation GKHomeMoreController
+ (instancetype)vcWithBookInfo:(GKBookInfo *)bookInfo{
    GKHomeMoreController *vc = [[[self class] alloc] init];
    vc.bookInfo = bookInfo;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:self.bookInfo.shortTitle];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager homeHot:self.bookInfo._id success:^(id  _Nonnull object) {
        self.bookInfo = [GKBookInfo modelWithJSON:object];
        [self showNavTitle:[NSString stringWithFormat:@"%@(%@)",self.bookInfo.shortTitle,@(self.bookInfo.total)]];
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookInfo.books.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKClassflyCell *cell = [GKClassflyCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.bookInfo.books[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKBookModel *model =  self.bookInfo.books[indexPath.row];
    [GKJumpApp jumpToBookDetail:model.bookId];
    
}


@end
