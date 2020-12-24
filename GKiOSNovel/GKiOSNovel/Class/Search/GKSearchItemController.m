//
//  GKSearchItemController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchItemController.h"
#import "GKClassflyCell.h"
#import "GKSearchTopView.h"
@interface GKSearchItemController ()<GKSearchTopDelegate>
@property (copy, nonatomic) NSString *hotWord;
@property (strong, nonatomic) GKBookInfo *bookInfo;
@property (strong, nonatomic) NSMutableArray *listData;

@property (strong, nonatomic) GKSearchTopView *topView;
@end

@implementation GKSearchItemController
+ (instancetype)vcWithHotWord:(NSString *)hotWord{
    GKSearchItemController *vc = [[[self class] alloc] init];
    vc.hotWord = hotWord;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData = @[].mutableCopy;
    [self showNavTitle:self.hotWord];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.topView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    self.topView.keyword = self.hotWord;
}
- (void)refreshData:(NSInteger)page{
    if (self.hotWord.length > 0) {
        [GKNovelNet homeSearch:self.hotWord page:page success:^(id  _Nonnull object) {
            self.bookInfo = [GKBookInfo modelWithJSON:object];
            if (page == RefreshPageStart) {
                [self.listData removeAllObjects];
            }
            self.bookInfo.books ? [self.listData addObjectsFromArray:self.bookInfo.books] : nil;
            [self.tableView reloadData];
            [self endRefresh:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSString * _Nonnull error) {
            [self endRefreshFailure];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKBookModel *model =  self.listData[indexPath.row];
    [GKJumpApp jumpToBookDetail:model.bookId];
    
}
- (GKSearchTopView *)topView{
    if (!_topView) {
        _topView = [GKSearchTopView instanceView];
        _topView.delegate = self;
    }
    return _topView;
}
#pragma mark GKSearchTopDelegate
- (void)searchTopView:(GKSearchTopView *)topView keyword:(NSString *)keyword{
    self.hotWord = keyword;
    [self refreshData:1];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)searchTopView:(GKSearchTopView *)topView goback:(BOOL)goback{
    [self goBack];
}
@end
