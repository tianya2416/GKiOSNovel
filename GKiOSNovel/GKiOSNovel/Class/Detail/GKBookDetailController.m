//
//  GKBookDetailController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailController.h"
#import "GKBookDetailCollectionCell.h"
#import "GKBookDetailModel.h"
#import "GKBookDetailTabbar.h"
#import "GKBookDetailView.h"
#import "GKBookDetailCell.h"
#import "GKHomeHotCell.h"
#import "GKHomeReusableView.h"
#import "GKBookDetailController.h"
@interface GKBookDetailController ()
@property (copy, nonatomic) NSString *bookId;
@property (strong, nonatomic) GKBookDetailTabbar *tabbar;
@property (strong, nonatomic) GKBookDetailView *detailView;
@property (strong, nonatomic) GKBookDetailInfo *bookDetail;
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
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [self.view addSubview:self.tabbar];
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabbar.superview);
        make.height.offset(49);
        make.bottom.equalTo(self.tabbar.superview).offset(-TAB_BAR_ADDING);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.collectionView.superview);
        make.bottom.equalTo(self.tabbar.mas_top);
    }];
    [GKBookCaseDataQueue getDataFromDataBase:self.bookId completion:^(GKBookDetailModel * _Nonnull bookModel) {
        if (bookModel) {
            [self reloadUI:YES];
        }
    }];
    
}
- (void)refreshData:(NSInteger)page{
    [GKBookDetailInfo bookDetail:self.bookId success:^(GKBookDetailInfo * _Nonnull info) {//55b37c89829afbb046b2ac82
        self.bookDetail = info;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
    
}
- (void)reloadUI:(BOOL)collection
{
    self.tabbar.collection = collection;
}
#pragma mark dataSource
- (void)addAction:(UIButton *)sender{
    
    if (sender.selected) {
        [ATAlertView showTitle:@"确定取消收藏" message:@"" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
            if (index > 0) {
                [GKBookCaseDataQueue deleteDataToDataBase:self.bookDetail.bookModel._id completion:^(BOOL success) {
                    if (success) {
                        [self reloadUI:NO];
                    }
                }];
            }
        }];
    }else{
        [GKBookCaseDataQueue insertDataToDataBase:self.bookDetail.bookModel completion:^(BOOL success) {
            if (success) {
                [self reloadUI:YES];
                [MBProgressHUD showMessage:@"收藏成功" toView:self.view];
            }
        }];
    }
}
- (void)readAction{
    [GKJumpApp jumpToReadBook:self.bookDetail.bookModel];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.bookDetail.listData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *list = self.bookDetail.listData[section];
    return list.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray *list = self.bookDetail.listData[section];
    return CGSizeMake(SCREEN_WIDTH, list.count > 0 && section >0 ? 45 : 0.001f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    res.moreBtn.hidden = YES;
    res.titleLab.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    res.titleLab.textColor = AppColor;
    res.titleLab.text = indexPath.section == 1 ?@"推荐书籍":@"推荐书单";
    return res;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = self.bookDetail.listData[indexPath.section];
    id object = list[indexPath.row];
    if ([object isKindOfClass:GKBookDetailModel.class]) {
        return CGSizeMake(SCREEN_WIDTH, [GKBookDetailCell heightForWidth:SCREEN_WIDTH model:object]);
    }else if ([object isKindOfClass:GKBookModel.class]){
        CGFloat width = (SCREEN_WIDTH)/3.0;
        CGFloat height = width * 1.35;
        return CGSizeMake(width, height);
    }else if ([object isKindOfClass:GKBookListModel.class]){
        return CGSizeMake(SCREEN_WIDTH,SCALEW(120));
    }
    return CGSizeMake(SCREEN_WIDTH, 0.001f);
}
//设置海报图片
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = self.bookDetail.listData[indexPath.section];
    id object = list[indexPath.row];
    if ([object isKindOfClass:GKBookDetailModel.class]) {
        GKBookDetailCell *cell = [GKBookDetailCell cellForCollectionView:collectionView indexPath:indexPath];
        cell.model = object;
        return cell;
    }else if ([object isKindOfClass:GKBookModel.class]){
        GKHomeHotCell *cell = [GKHomeHotCell cellForCollectionView:collectionView indexPath:indexPath];
        cell.model = object;
        return cell;
    }else if ([object isKindOfClass:GKBookListModel.class]){
        GKBookDetailCollectionCell *cell = [GKBookDetailCollectionCell cellForCollectionView:collectionView indexPath:indexPath];
        cell.model = object;
        return cell;
    }
    return [UICollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
}
#pragma mark delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = self.bookDetail.listData[indexPath.section];
    id object = list[indexPath.row];
    if ([object isKindOfClass:GKBookModel.class]){
        GKBookModel *model = object;
        [GKJumpApp jumpToBookDetail:model._id];
    }else if ([object isKindOfClass:GKBookListModel.class]){
        GKBookListModel *model = object;
        [GKJumpApp jumpToBookListDetail:model._id];
    }
}
#pragma mark get
- (GKBookDetailTabbar *)tabbar{
    if (!_tabbar) {
        _tabbar = [GKBookDetailTabbar instanceView];
        [_tabbar.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbar.readBtn addTarget:self action:@selector(readAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tabbar;
}

@end
