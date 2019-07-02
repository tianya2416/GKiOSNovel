//
//  GKClassItemController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKClassItemController.h"
#import "GKClassflyController.h"
#import "GKHomeHotCell.h"
#import "GKClassItemModel.h"
@interface GKClassItemController ()
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKClassItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    // Do any additional setup after loading the view.
}
- (void)setTitleName:(NSString *)titleName{
    if (![_titleName isEqualToString:titleName]) {
        _titleName = titleName;
    }
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager homeClass:self.titleName success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKClassItemModel.class json:object];
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
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
    return [collectionView ar_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop)/3 configuration:^(__kindof GKHomeHotCell *cell) {
        cell.model = self.listData[indexPath.row];
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCell *cell = [GKHomeHotCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];

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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKClassItemModel *model = self.listData[indexPath.row];
    GKClassflyController *vc = [GKClassflyController vcWithGroup:self.titleName name:model.name];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
