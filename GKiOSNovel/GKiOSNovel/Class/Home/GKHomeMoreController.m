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
@property (copy, nonatomic)GKBookInfo *bookInfo;
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
        self.listData = [NSArray modelArrayWithClass:GKBookModel.class json:object[@"books"]];
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
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKClassflyCell *cell = [GKClassflyCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
