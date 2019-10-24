//
//  GKBookDetailController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBookDetailController.h"
#import "GKBookDetailController.h"
#import "GKShareViewController.h"
#import "GKBookDetailCollectionCell.h"
#import "GKBookDetailModel.h"
#import "GKBookDetailTabbar.h"
#import "GKBookDetailView.h"
#import "GKBookDetailCell.h"
#import "GKHomeHotCell.h"
#import "GKHomeReusableView.h"
#import "GKBookCacheTool.h"
#import "ASProgressPopUpView.h"
@interface GKBookDetailController ()
@property (copy, nonatomic) NSString *bookId;
@property (strong, nonatomic) UILabel *tipLab;
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
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.fd_prefersNavigationBarHidden = YES;
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    //[self showNavTitle:@"书籍详情"];
    [self.view addSubview:self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.tipLab.superview);
    }];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [self.view addSubview:self.tabbar];
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabbar.superview);
        make.height.offset(49);
        make.bottom.equalTo(self.tabbar.superview).offset(-TAB_BAR_ADDING);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.collectionView.superview);
        make.bottom.equalTo(self.tabbar.mas_top);
    }];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.top.equalTo(backBtn.superview).offset(STATUS_BAR_HIGHT);
        make.left.equalTo(backBtn.superview).offset(10);
    }];
    [backBtn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.top.equalTo(shareBtn.superview).offset(STATUS_BAR_HIGHT);
        make.right.equalTo(shareBtn.superview).offset(-5);
    }];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
  //  [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareAction)];

}
- (void)loadData{
    NSLog(@"=========================");
    [GKBookCaseDataQueue getDataFromDataBase:self.bookId completion:^(GKBookDetailModel * _Nonnull bookModel) {
        NSLog(@"=========================");
        if (bookModel) {
            [self reloadUI:YES];
        }
    }];
    [GKBookReadDataQueue getDataFromDataBase:self.bookId completion:^(GKBookReadModel * _Nonnull bookModel) {
        [self setTipModel:bookModel];
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
        [ATAlertView showTitle:@"确定从书架中移除该小说吗？" message:@"" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
            if (index > 0) {
                [GKBookCaseDataQueue deleteDataToDataBase:self.bookDetail.bookModel.bookId completion:^(BOOL success) {
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
                [MBProgressHUD showMessage:@"已成功放入书架" toView:self.view];
            }
        }];
    }
}
- (void)readAction{
    [GKJumpApp jumpToBookRead:self.bookDetail.bookModel];
}
- (void)shareAction{
    [self presentPanModal:[GKShareViewController vcWithBookModel:self.bookDetail.bookModel]];
}
- (void)setTipModel:(GKBookReadModel *)bookModel{
    self.tipLab.hidden = !bookModel;

    GKBookChapterModel *model = [bookModel.chapterInfo.chapters objectSafeAtIndex:bookModel.chapter];
    self.tipLab.text = [NSString stringWithFormat:@"本书阅读到: %@\n%@",model.title,[GKTimeTool timeStampTurnToTimesType:bookModel.updateTime]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tipLab.superview);
            make.top.equalTo(self.tipLab.superview).offset(-35);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.tipLab.hidden = finished;
        }];
    });
}
#pragma mark UICollectionViewDataSource
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    NSArray *list = self.bookDetail.listData[section];
    return section == [list.firstObject isKindOfClass:GKBookModel.class] && section != 0? AppTop : 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    NSArray *list = self.bookDetail.listData[section];
    return section == [list.firstObject isKindOfClass:GKBookModel.class] && section != 0? AppTop : 0.0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSArray *list = self.bookDetail.listData[section];
    CGFloat top = [list.firstObject isKindOfClass:GKBookModel.class] && section != 0 ? AppTop : 0.0f;
    return UIEdgeInsetsMake(top,top,top,top);
}
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
    return CGSizeMake(SCREEN_WIDTH, (list.count > 0 && section >0) ? (section > 1 ? 25 : 40) : 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    res.moreBtn.hidden = YES;
    res.titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    res.titleLab.textColor = AppColor;
    res.titleLab.text = indexPath.section == 1 ?@"推荐书籍":@"推荐书单";
    return res;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = self.bookDetail.listData[indexPath.section];
    id object = list[indexPath.row];
    if ([object isKindOfClass:GKBookDetailModel.class]) {
        return [collectionView ar_sizeForCellWithClassCell:GKBookDetailCell.class indexPath:indexPath fixedValue:SCREEN_WIDTH configuration:^(__kindof GKBookDetailCell *cell) {
            cell.model = object;
        }];
    }else if ([object isKindOfClass:GKBookModel.class]){
        return [collectionView ar_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop)/3.0f configuration:^(__kindof GKHomeHotCell *cell) {
            cell.model = object;
        }];
    }else if ([object isKindOfClass:GKBookListModel.class]){
        return [collectionView ar_sizeForCellWithClassCell:GKBookDetailCollectionCell.class indexPath:indexPath fixedValue:SCREEN_WIDTH configuration:^(__kindof GKBookDetailCollectionCell * cell) {
            cell.model = object;
        }];
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
    if ([object isKindOfClass:GKBookDetailModel.class]) {
        return;
    }
    else if ([object isKindOfClass:GKBookModel.class]){
        GKBookModel *model = object;
        [GKJumpApp jumpToBookDetail:model.bookId];
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
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.font = [UIFont systemFontOfSize:12];
        _tipLab.textColor = AppColor;
        _tipLab.backgroundColor = [UIColor colorWithRGB:0xf6f6f6];
        _tipLab.numberOfLines = 3;
    }
    return _tipLab;
}
- (BOOL)shouldAutorotate {
    return NO;
}
@end
