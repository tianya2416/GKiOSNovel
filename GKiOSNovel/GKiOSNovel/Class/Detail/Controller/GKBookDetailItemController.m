//
//  GKChapterController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKBookDetailItemController.h"
#import "GKHomeHotCell.h"
#import "GKBookDetaiContentCell.h"
@interface GKBookDetailItemController ()
@property (copy, nonatomic) NSString *bookId;
@end

@implementation GKBookDetailItemController
+ (instancetype)vcWithBookId:(NSString *)bookId{
    GKBookDetailItemController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    return vc;
}
- (void)setModel:(GKBookDetailModel *)model{
    _model = model;
    [self.tableView reloadData];
    [self endRefresh:false];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GKNovelNet updateContent:self.bookId success:^(id object) {
            
    } failure:^(NSString *error) {
            
    }];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookDetaiContentCell *cell = [GKBookDetaiContentCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.model;
    return cell;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return (170 + NAVI_BAR_HIGHT)/2;
}
@end
@interface GKBookDetailRecomController ()
@property (copy, nonatomic) NSString *bookId;

@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKBookDetailRecomController
+ (instancetype)vcWithBookId:(NSString *)bookId{
    GKBookDetailRecomController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNet bookCommend:self.bookId success:^(id object) {
        self.listData = [NSArray modelArrayWithClass:GKBookModel.class json:object[@"books"]];
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString *error) {
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
    return  [collectionView at_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop-1)/3 caculateType:ATDynamicTypeWidth config:^(__kindof GKHomeHotCell * cell) {
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
    return UIEdgeInsetsMake(AppTop,AppTop,5,AppTop);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   // GKBookInfo *info = self.listData[indexPath.section];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return (170 + NAVI_BAR_HIGHT)/2;
}
@end


@interface GKBookListRecomController ()
@property (copy, nonatomic) NSString *bookId;

@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKBookListRecomController
+ (instancetype)vcWithBookId:(NSString *)bookId{
    GKBookListRecomController *vc = [[[self class] alloc] init];
    vc.bookId = bookId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    [GKNovelNet bookListCommend:self.bookId success:^(id object) {
        self.listData = [NSArray modelArrayWithClass:GKBookListModel.class json:object[@"booklists"]];
        [self.collectionView reloadData];
        [self endRefresh:NO];
        } failure:^(NSString *error) {
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
    return  [collectionView at_sizeForCellWithClassCell:GKHomeHotCell.class indexPath:indexPath fixedValue:(SCREEN_WIDTH - 4*AppTop-1)/3 caculateType:ATDynamicTypeWidth config:^(__kindof GKHomeHotCell * cell) {
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
    return UIEdgeInsetsMake(AppTop,AppTop,5,AppTop);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   // GKBookInfo *info = self.listData[indexPath.section];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return (170 + NAVI_BAR_HIGHT)/2;
}
@end
