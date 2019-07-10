//
//  GKSearchHistoryController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchHistoryController.h"
#import "GKSearchItemController.h"
#import "GKCollectionViewLayout.h"
#import "GKSearchTextView.h"
#import "GKHomeReusableView.h"
#import "GKStartCell.h"
@interface GKSearchHistoryController ()<UITextFieldDelegate>
@property (strong, nonatomic) GKSearchTextView *searchView;
@property (strong, nonatomic) GKCollectionViewLayout *layout;
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSMutableArray *searchDatas;
@end

@implementation GKSearchHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchDatas = @[].mutableCopy;
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.searchView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.collectionView.superview);
        make.top.equalTo(self.searchView.mas_bottom);
    }];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    NSArray *datas = [BaseMacro hotDatas];
    [GKSearchDataQueue getDatasFromDataBase:page pageSize:RefreshPageSize completion:^(NSArray<NSString *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.searchDatas removeAllObjects];
        }
        listData.count ? [self.searchDatas addObjectsFromArray:listData] : nil;
        NSInteger index = arc4random() % (datas.count - 6);
        self.listData = [datas subarrayWithRange:NSMakeRange(index, 6)];
        [self.collectionView reloadData];
        [self endRefresh:listData.count >= RefreshPageSize];
    }];
    
    
}
- (void)deleteAction{
    [ATAlertView showTitle:@"确定要删除所有历史记录？" message:@"" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [GKSearchDataQueue deleteDatasToDataBase:self.searchDatas.copy completion:^(BOOL success) {
                if (success) {
                    [self headerRefreshing];
                }
            }];
        }
    }];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? self.listData.count : self.searchDatas.count;
}
//设置海报图片
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKStartCell *cell = [GKStartCell cellForCollectionView:collectionView indexPath:indexPath startState:GKStartStateBoard];
    NSArray *listData = indexPath.section == 0 ? self.listData : self.searchDatas.copy;
    cell.titleLab.text = listData[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, section == 0 ?(self.listData.count ? 40 : 0.01): (self.searchDatas.count ?  40 : 0.01));
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    NSArray *listData = indexPath.section == 0 ? self.listData : self.searchDatas.copy;
    res.titleLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    res.hidden = listData.count == 0;
    if (indexPath.section == 0) {
        res.titleLab.text = @"热门词语";
        res.titleLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [res.moreBtn setTitle:@"换一换" forState:UIControlStateNormal];
    }else{
        res.titleLab.text = @"历史记录";
        [res.moreBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    @weakify(self)
    [res.moreBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        indexPath.section == 0 ? [self headerRefreshing]  : [self deleteAction];
    }];
    return res;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,10,10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData = indexPath.section == 0 ? self.listData : self.searchDatas.copy;
    NSString *title = listData[indexPath.row];
    CGFloat width = [title sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByTruncatingTail].width;
    return CGSizeMake(width + 20, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *listData = indexPath.section == 0 ? self.listData : self.searchDatas.copy;
    [self searchText:listData[indexPath.row]];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [GKSearchDataQueue insertDataToDataBase:content completion:^(BOOL success) {
        if (success) {
            [self headerRefreshing];
        }
    }];
    [self searchText:content];
    return YES;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return textField == self.searchView.textField ? NO : YES;
//}
- (void)searchText:(NSString *)searchText{
    GKSearchItemController *vc = [GKSearchItemController vcWithHotWord:searchText];
    [self.navigationController pushViewController:vc animated:YES];
}
- (GKSearchTextView *)searchView{
    if (!_searchView) {
        _searchView = [GKSearchTextView instanceView];
        _searchView.textField.delegate = self;
        [_searchView.cancleBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchView;
}
//- (void)goBack{
//    [self goBack:NO];
//}
@end
