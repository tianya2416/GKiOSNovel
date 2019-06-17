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
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKHomeController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请点击右上角进行添加"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_nav_add"] action:@selector(addAction)];
    [GKUserManager reloadHomeDataNeed:^(BOOL loadData) {
        if (loadData) {
            [self headerRefreshing];
        }
    }];
    
}
- (void)refreshData:(NSInteger)page{
    NSArray <GKRankModel *>*listData = [GKUserManager shareInstance].user.rankDatas;
    [GKHomeNetManager homeNet:listData success:^(NSArray<GKBookInfo *> * _Nonnull datas) {
        self.listData = datas;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
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
    GKBookModel *model = info.listData[indexPath.row];
    cell.model = model;
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
    GKBookInfo *info = self.listData[indexPath.section];
    res.titleLab.text = info.shortTitle ?:@"";
    @weakify(self)
    [res.moreBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        GKHomeMoreController *vc = [GKHomeMoreController vcWithBookInfo:info];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return res;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKBookInfo *info = self.listData[indexPath.section];
    GKBookModel *model = info.listData[indexPath.row];
    [GKJumpApp jumpToBookDetail:model._id];
}
@end
