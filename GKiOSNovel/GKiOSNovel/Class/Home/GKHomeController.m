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
@interface GKHomeController()
@property (strong, nonatomic) GKHomeNetManager *homeManager;
@property (strong, nonatomic) NSArray <GKBookInfo *>*listData;
@property (assign, nonatomic) GKLoadDataState option;
@property (strong, nonatomic) UIButton *tipBtn;
@end

@implementation GKHomeController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    self.listData = @[].mutableCopy;
    self.option = GKLoadDataDefault;
    [GKUserManager reloadHomeDataNeed:^(GKLoadDataState option) {
        self.option = option;
        [self headerRefreshing];
    }];
    
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请点击右上角进行添加"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    
    
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_nav_add"] action:@selector(addAction)];
    [self.view addSubview:self.tipBtn];
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.tipBtn.superview);
    }];
}
- (void)setOption:(GKLoadDataState)option{
    _option = option;
    if (_option & GKLoadDataDataBase) {
        @weakify(self)
        [GKBookReadDataQueue getDatasFromDataBase:1 pageSize:10 completion:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
            if (listData.count) {
                @strongify(self)
                GKBookReadModel *model = listData.firstObject;
                NSString *title = [NSString stringWithFormat:@"最近一次阅读:%@ %@",model.bookModel.title?:@"",[GKTimeTool timeStampTurnToTimesType:model.updateTime]];
                [self.tipBtn setTitle:title forState:UIControlStateNormal];
                [self.tipBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    [GKJumpApp jumpToBookRead:model.bookModel];
                }];
            }
        }];
    }
}
- (void)loadData{

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
- (void)addAction{
    [GKJumpApp jumpToAddSelect];
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
    CGFloat width = (SCREEN_WIDTH)/3.0;
    CGFloat height = width * 1.35;
    return CGSizeMake(width, height);
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
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    GKBookInfo *info = self.listData[section];
    return CGSizeMake(SCREEN_WIDTH, info.listData.count ? 60 : 0.001f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    GKBookInfo *info =  self.listData[indexPath.section];
    if ([info isKindOfClass:GKBookInfo.class]) {
        res.titleLab.text = info.shortTitle ?:@"";
        res.moreBtn.hidden = info.books.count <=6;
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
         [GKJumpApp jumpToBookDetail:model._id];
    }else if ([model isKindOfClass:GKBookReadModel.class]){
        GKBookReadModel *info = (GKBookReadModel *)model;
         [GKJumpApp jumpToBookDetail:info.bookModel._id];
    }
}
#pragma mark get
- (GKHomeNetManager *)homeManager{
    if (!_homeManager) {
        _homeManager = [[GKHomeNetManager alloc] init];
    }
    return _homeManager;
}
- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipBtn.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        _tipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_tipBtn setTitleColor:AppColor forState:UIControlStateNormal];
        [_tipBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 5,5, 5)];
        _tipBtn.titleLabel.numberOfLines = 0;
    }return _tipBtn;
}
@end
