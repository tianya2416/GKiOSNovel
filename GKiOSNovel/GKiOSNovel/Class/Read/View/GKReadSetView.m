//
//  GKReadSetView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadSetView.h"
#import "GKReadSetCell.h"
@interface GKReadSetView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKReadSetView
- (void)dealloc{
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadUI];
        [self loadData];
    }return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
        [self loadData];
    }return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadUI];
    [self loadData];
}

- (void)loadUI{
    [self.moreSet setTitleColor:AppColor forState:UIControlStateNormal];
    self.switchBtn.onTintColor = AppColor;
    self.backgroundColor = Appx252631;
    self.slider.thumbTintColor = AppColor;
    self.slider.minimumTrackTintColor = AppColor;
    self.slider.maximumTrackTintColor = Appxdddddd;
    UIImage *image  = [self circleImageWithName:[self originImage:[UIImage imageWithColor:AppColor] scaleToSize:CGSizeMake(15, 15)] borderWidth:2 borderColor:Appxdddddd];
    [self.slider setThumbImage:image forState:UIControlStateNormal];
    [self.slider setThumbImage:image forState:UIControlStateHighlighted];
    [self.slider addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(touchUpACtion:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.segmentControl.tintColor = AppColor;
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [self.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate  = self;
    
    self.collectionView.backgroundColor = self.collectionView.backgroundView.backgroundColor = Appx252631;
    
    [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreSet addTarget:self action:@selector(moreSetActon) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changedAction:(UISlider *)slder{
    CGFloat brightness = slder.value;
    [[UIScreen mainScreen] setBrightness:brightness];
}
- (void)touchUpACtion:(UISlider *)slder{
    CGFloat brightness = slder.value;
    NSLog(@"%@",@(brightness));
    if ([self.delegate respondsToSelector:@selector(readSetView:brightness:)]) {
        [self.delegate readSetView:self brightness:brightness];
    }
}
- (void)segmentAction:(UISegmentedControl *)sender{
    CGFloat font = 2*sender.selectedSegmentIndex + 18;
    [GKReadSetManager setFont:font];
    if ([self.delegate respondsToSelector:@selector(readSetView:font:)]) {
        [self.delegate readSetView:self font:font];
    }
}
- (void)switchAction:(UISwitch *)sender{
     [GKReadSetManager setLandscape:sender.on];
    if ([self.delegate respondsToSelector:@selector(readSetView:screen:)]) {
        [self.delegate readSetView:self screen:sender.on];
    }
}
- (void)moreSetActon{
    if ([self.delegate respondsToSelector:@selector(readSetView:moreSet:)]) {
        [self.delegate readSetView:self moreSet:YES];
    }
}
- (void)loadData{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    self.slider.value = [UIScreen mainScreen].brightness;
    self.segmentControl.selectedSegmentIndex = (model.font - 18)/2;
    self.listData = [GKReadSetManager defaultSkinDatas];
    self.switchBtn.on = model.landscape;
    [self.collectionView reloadData];
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (UIImage *)circleImageWithName:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
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
    return UIEdgeInsetsMake(15,15,15,15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 50);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKReadSetCell * cell  = [GKReadSetCell cellForCollectionView:collectionView indexPath:indexPath];
    GKReadSkinModel *model = self.listData[indexPath.row];
    cell.titleLab.text = model.title;
    cell.imageV.image = [UIImage imageNamed:model.skin];
    cell.imageIcon.hidden = model.state != [GKReadSetManager shareInstance].model.state;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKReadSkinModel *model = self.listData[indexPath.row];
    if (model.state == [GKReadSetManager shareInstance].model.state) {
        return;
    }
    [GKReadSetManager setReadState:model.state];
    if ([self.delegate respondsToSelector:@selector(readSetView:state:)]) {
        [self.delegate readSetView:self state:model.state];
    }
    [self loadData];
}
@end
