//
//  GKMineSelectController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMineSelectController.h"
#import "GKStartCell.h"
@interface GKMineSelectController ()
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) GKRankInfo *rankInfo;
@end

@implementation GKMineSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"选择一项或者多项做为首页数据"];
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sureBtn.superview).offset(10);
        make.right.equalTo(self.sureBtn.superview).offset(-10);
        make.bottom.offset(-(TAB_BAR_ADDING + 10));
        make.height.offset(45);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView.superview);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-10);
        make.top.equalTo(self.collectionView.superview).offset(0);
    }];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager rankSuccess:^(id  _Nonnull object) {
        self.rankInfo = [GKRankInfo modelWithJSON:object];
        self.rankInfo.state = [GKUserManager shareInstance].user.state;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (void)sureAction{
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"select = %@",@(YES)];
    NSArray * array  = [self.rankInfo.listData filteredArrayUsingPredicate:pre1];
    GKUserModel *user = [GKUserModel vcWithState:self.rankInfo.state rankDatas:array];
    [GKUserManager saveUserModel:user];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GKUserManager reloadHomeData:GKLoadDataDefault];
        [self goBack];
    });
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rankInfo.listData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 4*25)/3.0;
    CGFloat height = 40;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25,25,25,25);
}
//设置海报图片
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKStartCell *cell = [GKStartCell cellForCollectionView:collectionView indexPath:indexPath];
    GKRankModel *model = self.rankInfo.listData[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GKRankModel *model = self.rankInfo.listData[indexPath.row];
    model.select = !model.select;
    [collectionView reloadData];
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:Appxffffff forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = AppRadius;
    }
    return _sureBtn;
}
@end
