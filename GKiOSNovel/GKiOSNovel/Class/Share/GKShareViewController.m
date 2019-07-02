//
//  GKShareViewController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKShareViewController.h"
#import "GKShareViewCell.h"
@interface GKShareViewController ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) GKBookListDetailModel *model;
@property (strong, nonatomic) GKBookDetailModel *bookModel;

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSMutableArray *listImages;
@end

@implementation GKShareViewController
+ (instancetype)vcWithBookModel:(GKBookDetailModel *)model{
    GKShareViewController *vc = [[[self class] alloc] init];
    vc.bookModel = model;
    return vc;
}
+ (instancetype)vcWithBookListModel:(GKBookListDetailModel *)model{
    GKShareViewController *vc = [[[self class] alloc] init];
    vc.model = model;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupEmpty:self.collectionView];
//    [self setupRefresh:self.self.collectionView option:ATRefreshNone];
    [self.view addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLab.superview);
        make.top.equalTo(self.titleLab.superview).offset(15);
    }];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancleBtn.superview).offset(15);
        make.right.equalTo(self.cancleBtn.superview).offset(-15);
        make.height.offset(45);
        make.bottom.equalTo(self.cancleBtn.superview).offset(-15-TAB_BAR_ADDING);
    }];
    
    self.listImages = @[@"icon_wechat",@"icon_line",@"icon_qq",@"icon_qqzone"].mutableCopy;
    self.listData = @[@"微信",@"朋友圈",@"QQ",@"QQ空间"].mutableCopy;
    if (self.model) {
        [self.listImages addObject:@"icon_system"];
        [self.listImages addObject:@"icon_copy"];
        [self.listData addObject:@"系统分享"];
        [self.listData addObject:@"复制"];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView.superview);
        make.top.equalTo(self.titleLab.mas_bottom);
        make.bottom.equalTo(self.cancleBtn.mas_top);
    }];
}
//- (void)refreshData:(NSInteger)page{
//    [self.collectionView reloadData];
//    [self endRefresh:NO];
//}
- (void)shareAction:(UIButton *)sender{
    if (self.bookModel) {
        [GKShareTool shareTo:sender.tag imageUrl:self.bookModel.cover title:self.bookModel.title subTitle:self.bookModel.longIntro completion:^(NSString * _Nonnull error) {
            [MBProgressHUD showMessage:error];
        }];
    }else if (self.model){
        [GKShareTool shareType:sender.tag url:self.model.shareLink title:self.model.title subTitle:self.model.desc compeletion:^(NSString * _Nonnull error) {
            [MBProgressHUD showMessage:error];
        }];
    }
}
#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/(self.listData.count > 4 ? 4.5 : self.listData.count), 90);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKShareViewCell *cell = [GKShareViewCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:self.listImages[indexPath.row]];
    cell.titleLab.text = self.listData[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 4:
        {
            [GKShareTool shareSystem:self.model.title url:self.model.shareLink compeletion:^(NSString * _Nonnull error) {
                [MBProgressHUD showMessage:error];
            }];
        }break;
        case 5:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.model.shareLink;
            [MBProgressHUD showMessage:@"复制成功"];
        }break;
        default:
        {
            if (self.bookModel) {
                [GKShareTool shareTo:indexPath.row imageUrl:self.bookModel.cover title:self.bookModel.title subTitle:self.bookModel.longIntro completion:^(NSString * _Nonnull error) {
                    [MBProgressHUD showMessage:error];
                }];
            }else if (self.model){
                [GKShareTool shareType:indexPath.row url:self.model.shareLink title:self.model.title subTitle:self.model.desc compeletion:^(NSString * _Nonnull error) {
                    [MBProgressHUD showMessage:error];
                }];
            }
        }break;
    }
}
#pragma mark HWPanModalPresentable
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent,210);
}
- (BOOL)showDragIndicator {
    return NO;
}
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    return NO;
}
#pragma mark get
- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleBtn setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
        _cancleBtn.layer.masksToBounds = YES;
        _cancleBtn.layer.cornerRadius = AppRadius;
        [_cancleBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"分享到";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = Appx999999;
    }
    return _titleLab;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}
@end
