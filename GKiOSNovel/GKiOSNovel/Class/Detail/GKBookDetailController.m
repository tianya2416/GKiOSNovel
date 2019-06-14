//
//  GKBookDetailController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailController.h"
#import "GKBookDetailModel.h"
#import "GKBookDetailTabbar.h"
@interface GKBookDetailController ()
@property (copy, nonatomic) NSString *bookId;
@property (strong, nonatomic) GKBookDetailTabbar *tabbar;
@property (strong, nonatomic) GKBookDetailModel *bookModel;
@end

@implementation GKBookDetailController
+ (instancetype)vcWithBookId:(NSString *)bookId{
    GKBookDetailController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"书籍详情"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    [self.view addSubview:self.tabbar];
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabbar.superview);
        make.height.offset(49);
        make.bottom.equalTo(self.tabbar.superview).offset(-TAB_BAR_ADDING);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tabbar.mas_top);
    }];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager bookDetail:self.bookId success:^(id  _Nonnull object) {
        self.bookModel = [GKBookDetailModel modelWithJSON:object];
        [self endRefresh:NO];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}

- (GKBookDetailTabbar *)tabbar{
    if (!_tabbar) {
        _tabbar = [GKBookDetailTabbar instanceView];
    }
    return _tabbar;
}

@end
