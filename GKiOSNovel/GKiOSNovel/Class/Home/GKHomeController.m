//
//  GKHomeController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeController.h"
#import "GKHomeMoreController.h"
#import "GKHomeReusableView.h"
#import "GKHomeHotCell.h"
#import "GKHomeNetManager.h"
#import "KLRecycleScrollView.h"
#import "GKNewNavBarView.h"
#import "GKStartViewController.h"
#import "GKSearchHistoryController.h"
@interface GKHomeController()<KLRecycleScrollViewDelegate>
@property (strong, nonatomic) GKHomeNetManager *homeManager;
@property (strong, nonatomic) NSArray <GKBookInfo *>*listData;
@property (assign, nonatomic) GKLoadDataState option;

@property (strong, nonatomic) NSArray *listHotWords;
@property (strong, nonatomic) GKNewNavBarView *navBarView;
@property (nonatomic, strong) KLRecycleScrollView *vmessage;
@end

@implementation GKHomeController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navBarView.state = [GKUserManager shareInstance].user.state;
}
- (void)loadUI{
    
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.navBarView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.collectionView.superview);
        make.top.equalTo(self.navBarView.mas_bottom).offset(0);
    }];
    [self.navBarView.mainView addSubview:self.vmessage];
    UIScrollView *scrow = [self.vmessage valueForKey:@"scrollView"];
    if (scrow) {
        scrow.scrollsToTop = NO;
    }
}
- (void)setOption:(GKLoadDataState)option{
    _option = option;
    if (_option & GKLoadDataDataBase) {
        [GKBookReadDataQueue getDatasFromDataBase:1 pageSize:10 completion:^(NSArray<GKBookReadModel *> * _Nonnull listData) {


        }];
    }
}
- (void)loadData{
    self.listData = @[].mutableCopy;
    self.option = GKLoadDataDefault;
    [GKUserManager reloadHomeDataNeed:^(GKLoadDataState option) {
        self.option = option;
        [self headerRefreshing];
    }];
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请点击右上角进行添加"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    self.listHotWords = [BaseMacro hotDatas];
    [self.vmessage reloadData:self.listHotWords.count];
}
- (void)refreshData:(NSInteger)page{
    NSArray <GKRankModel *>*listData = [GKUserManager shareInstance].user.rankDatas;
    @weakify(self)
    [self.homeManager homeNet:listData loadData:self.option success:^(NSArray<GKBookInfo *> * _Nonnull datas) {
        @strongify(self)
        self.listData = datas;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        @strongify(self)
        if (!self.reachable) {
            [self endRefreshFailure];
        }else{
            self.listData = @[];
            [self.collectionView reloadData];
            [self endRefresh:NO];
        }
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.listData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GKBookInfo *info = self.listData[section];
    return info.listData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKBookInfo *info = self.listData[indexPath.section];
    GKBookModel *model = info.listData[indexPath.row];
    return [collectionView ar_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop)/3 configuration:^(__kindof GKHomeHotCell *cell) {
        if ([model isKindOfClass:GKBookModel.class]) {
            cell.model = model;
        }else if ([model isKindOfClass:GKBookReadModel.class]){
            GKBookReadModel *info = (GKBookReadModel *)model;
            cell.model = info.bookModel;
        }
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCell *cell = [GKHomeHotCell cellForCollectionView:collectionView indexPath:indexPath];
    GKBookInfo *info = self.listData[indexPath.section];
    if ([info isKindOfClass:GKBookInfo.class]) {
        GKBookModel *model = info.listData[indexPath.row];
        if ([model isKindOfClass:GKBookModel.class]) {
            cell.model = model;
        }else if ([model isKindOfClass:GKBookReadModel.class]){
            GKBookReadModel *info = (GKBookReadModel *)model;
            cell.model = info.bookModel;
        }
    }
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(AppTop,AppTop,AppTop,AppTop);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    GKBookInfo *info = self.listData[section];
    return CGSizeMake(SCREEN_WIDTH, info.listData.count ? (section == 0 ?45 :30 ) : 0.001f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    GKBookInfo *info =  self.listData[indexPath.section];
    if ([info isKindOfClass:GKBookInfo.class]) {
        res.titleLab.text = info.shortTitle ?:@"";
        res.moreBtn.hidden = !info.moreData;
        @weakify(self)
        [res.moreBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            if ([info.listData.firstObject isKindOfClass:GKBookDetailModel.class]) {
                [GKJumpApp jumpToBookCase];
            }else if([info.listData.firstObject isKindOfClass:GKBookModel.class]){
                GKHomeMoreController *vc = [GKHomeMoreController vcWithBookInfo:info];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [GKJumpApp jumpToBookHistory];
            }
        }];
    }
    return res;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKBookInfo *info = self.listData[indexPath.section];
    GKBookModel *model = info.listData[indexPath.row];
    if ([model isKindOfClass:GKBookModel.class]) {
         [GKJumpApp jumpToBookDetail:model.bookId];
    }else if ([model isKindOfClass:GKBookReadModel.class]){
        GKBookReadModel *info = (GKBookReadModel *)model;
        [GKJumpApp jumpToBookRead:info.bookModel];
    }
}
#pragma mark KLRecycleScrollViewDelegate
- (UIView *)recycleScrollView:(KLRecycleScrollView *)recycleScrollView viewForItemAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = Appx333333;
    label.text = self.listHotWords[index];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
- (void)recycleScrollView:(KLRecycleScrollView *)recycleScrollView didSelectView:(UIView *)view forItemAtIndex:(NSInteger)index{
    [self searchAction];
}
- (void)addStartAction{
    GKStartViewController *vc = [[GKStartViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction{
    GKSearchHistoryController *vc = [[GKSearchHistoryController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark get
- (GKHomeNetManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[GKHomeNetManager alloc] init];
    }
    return _homeManager;
}
- (KLRecycleScrollView *)vmessage{
    if (!_vmessage) {
        _vmessage = [[KLRecycleScrollView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 100, 35)];
        _vmessage.delegate = self;
        _vmessage.direction = KLRecycleScrollViewDirectionTop;
        _vmessage.pagingEnabled = NO;
        _vmessage.timerEnabled = YES;
        _vmessage.scrollInterval = 5;
        _vmessage.backgroundColor = [UIColor whiteColor];
    }
    return _vmessage;
}
- (GKNewNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [GKNewNavBarView instanceView];
        [_navBarView.moreBtn addTarget:self action:@selector(addStartAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
