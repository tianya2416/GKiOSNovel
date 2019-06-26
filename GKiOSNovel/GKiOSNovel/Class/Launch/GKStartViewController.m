//
//  GKStartViewController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKStartViewController.h"
#import "GKCollectionViewLayout.h"
#import "GKHomeReusableView.h"
#import "GKRankModel.h"
#import "GKStartCell.h"
@interface GKStartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) UIButton *sureBtn;
@property (copy, nonatomic)void(^completion)(void);
@property (strong, nonatomic) GKRankInfo *rankInfo;
@property (strong, nonatomic) GKCollectionViewLayout *layout;
@property (assign, nonatomic) GKUserState userState;
@end

@implementation GKStartViewController
+ (instancetype)vcWithCompletion:(void(^)(void))completion{
    GKStartViewController *vc = [[[self class] alloc] init];
    vc.completion = completion;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"修改性别"];
    self.titleLab.textColor = AppColor;
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
        make.top.equalTo(self.collectionView.superview).offset(SCREEN_HEIGHT/2);
    }];
    [self setupEmpty:self.collectionView image:nil title:@""];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNetManager rankSuccess:^(id  _Nonnull object) {
        self.rankInfo = [GKRankInfo modelWithJSON:object];
        self.userState = [GKUserManager shareInstance].user.state ?: GKUserBoy;
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (void)setUserState:(GKUserState)userState{
    if (_userState != userState) {
        _userState = userState;
        _userState == GKUserBoy ? [self boyAction] : [self girlAction];
        self.titleLab.text = _userState == GKUserBoy ? @"我是小哥哥":@"我是小姐姐";
        self.rankInfo.state = _userState;
        self.layout.dataArr = self.rankInfo.listData;
        [self.collectionView reloadData];
    }
}

- (void)boyAction{
    //e8989a
    self.boyBtn.layer.masksToBounds = YES;
    self.boyBtn.layer.cornerRadius = AppRadius;
    self.boyBtn.layer.borderWidth = 4.0f;
    self.boyBtn.layer.borderColor = AppColor.CGColor;
    self.girlBtn.layer.borderColor = Appxffffff.CGColor;
    
}
- (void)girlAction{
    self.girlBtn.layer.masksToBounds = YES;
    self.girlBtn.layer.cornerRadius = AppRadius;
    self.girlBtn.layer.borderWidth = 4.0f;
    self.girlBtn.layer.borderColor = AppColor.CGColor;
    self.boyBtn.layer.borderColor = Appxffffff.CGColor;
}

- (IBAction)boyAction:(id)sender {
     self.userState = GKUserBoy;
}
- (IBAction)girlAction:(id)sender {
     self.userState = GKUserGirl;
}
- (void)sureAction{
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"select = %@",@(YES)];
    NSArray * array  = [self.rankInfo.listData filteredArrayUsingPredicate:pre1];
    if (array.count == 0) {
        [ATAlertView showTitle:@"选择一个或者多个做为首页推荐吧！" message:@"" normalButtons:@[@"确定"] highlightButtons:nil completion:nil];
        return;
    }
    GKUserModel *user = [GKUserModel vcWithState:self.userState rankDatas:array];
    [GKUserManager saveUserModel:user];
    if (self.completion) {
        !self.completion ?: self.completion();
    }else{
        [GKUserManager reloadHomeData:GKLoadDataDefault];
        [self goBack];
    }
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
//设置海报图片
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKStartCell *cell = [GKStartCell cellForCollectionView:collectionView indexPath:indexPath];
    GKRankModel *model = self.rankInfo.listData[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, self.rankInfo.listData.count ? 40 : 0.001f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GKHomeReusableView *res = [GKHomeReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    res.titleLab.text = @"选择2-4项做为首页推荐吧!";
    res.titleLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    return res;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GKRankModel *model = self.rankInfo.listData[indexPath.row];
    model.select = !model.select;
    [collectionView reloadData];
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        GKCollectionViewLayout *layout = [[GKCollectionViewLayout alloc] init];
        self.layout = layout;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
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
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
