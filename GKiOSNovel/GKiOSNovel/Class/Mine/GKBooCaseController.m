//
//  GKBooCaseController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBooCaseController.h"
#import "GKHomeHotCell.h"
@interface GKBooCaseController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKBooCaseController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showNavTitle:@"书架"];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请到数据详情页收藏你喜欢的书籍吧"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self headerRefreshing];
}
- (void)refreshData:(NSInteger)page{
    [GKBookCaseDataQueue getDatasFromDataBase:page pageSize:RefreshPageSize completion:^(NSArray<NSString *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        if (listData) {
            [self.listData addObjectsFromArray:listData];
        }
        [self.collectionView reloadData];
        self.listData.count == 0  ? [self endRefreshFailure] : [self endRefresh:listData.count >= RefreshPageSize];
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
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
    GKBookModel *model = self.listData[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, self.listData.count ? 15 : 0.001f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [UICollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKBookModel *model = self.listData[indexPath.row];
    [GKJumpApp jumpToBookDetail:model._id];
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
