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
    CGFloat width = (SCREEN_WIDTH)/3.0;
    CGFloat height = width * 1.35;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCell *cell = [GKHomeHotCell cellForCollectionView:collectionView indexPath:indexPath];
    GKClassItemModel *model = self.listData[indexPath.row];
    [cell.imageV setGkImageWithURL:model.icon];
    cell.titleLab.text = model.name ?:@"";
    [cell.tagBtn setTitle:[NSString stringWithFormat:@"月票:%@",model.monthlyCount] forState:UIControlStateNormal];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKClassItemModel *model = self.listData[indexPath.row];
    GKClassflyController *vc = [GKClassflyController vcWithGroup:self.titleName name:model.name];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
