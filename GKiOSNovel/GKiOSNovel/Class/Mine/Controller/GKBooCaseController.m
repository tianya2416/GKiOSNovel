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
@property (assign, nonatomic) BOOL needRequesst;
@property (assign, nonatomic) BOOL editor;
@end

@implementation GKBooCaseController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showNavTitle:@"我的书架"];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请到书籍详情页收藏你喜欢的书籍吧"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    self.needRequesst = NO;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needRequesst) {
        [self headerRefreshing];
    }
    self.needRequesst = YES;
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
    return [collectionView ar_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop)/3 configuration:^(__kindof GKHomeHotCell *cell) {
        cell.model = self.listData[indexPath.row];
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCell *cell = [GKHomeHotCell cellForCollectionView:collectionView indexPath:indexPath];
    @weakify(self)
    @weakify(cell)
    [cell.deleteBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        @strongify(cell)
        [self deleteAction:cell.model];
    }];
    GKBookModel *model = self.listData[indexPath.row];
    cell.model = model;
    cell.deleteBtn.hidden = !self.editor;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [UICollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
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
    GKBookModel *model = self.listData[indexPath.row];
    [GKJumpApp jumpToBookDetail:model._id];
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.editor;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [self.listData exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)deleteAction:(GKBookModel *)model{
    [ATAlertView showTitle:[NSString stringWithFormat:@"确定将%@从书架中移除",model.title] message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [GKBookCaseDataQueue deleteDataToDataBase:model._id completion:^(BOOL success) {
                if (success) {
                    [self.listData removeObject:model];
                    self.editor = NO;
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            if (!indexPath) {
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            self.editor = !self.editor;
            [self.collectionView reloadData];
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}


@end
