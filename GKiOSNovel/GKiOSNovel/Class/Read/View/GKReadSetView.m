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
@property (weak, nonatomic) IBOutlet UIButton *scrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *scralBtn;
@property (weak, nonatomic) IBOutlet UIButton *animaBtn;
@property (strong, nonatomic) NSArray *buttonDatas;

@end

@implementation GKReadSetView
- (void)dealloc{
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1;
    self.slider.thumbTintColor = AppColor;
    self.slider.minimumTrackTintColor = AppColor;
    self.slider.maximumTrackTintColor = [UIColor colorWithRGB:0xe8e8e8];
    UIImage *image  = [GKReadSetView circleImageWithName:[GKReadSetView originImage:[UIImage imageWithColor:AppColor] scaleToSize:CGSizeMake(5, 5)] borderWidth:6 borderColor:[UIColor colorWithRGB:0xf8f8f8]];
    [self.slider setThumbImage:image forState:UIControlStateNormal];
    [self.slider setThumbImage:image forState:UIControlStateHighlighted];

    [self.slider addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(outsideAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate  = self;
    
    self.collectionView.backgroundColor = self.collectionView.backgroundView.backgroundColor = Appxffffff;
    
    self.downBtn.layer.masksToBounds = YES;
    self.downBtn.layer.cornerRadius = AppRadius;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = AppRadius;
    self.downBtn.layer.borderWidth = self.addBtn.layer.borderWidth = 1.0f;
    self.downBtn.layer.borderColor = self.addBtn.layer.borderColor = [UIColor colorWithRGB:0xdcdcdc].CGColor;
    
    self.buttonDatas = @[self.scrowBtn,self.scralBtn,self.animaBtn];
    
}
- (void)touchUpAction:(UISlider *)slider{
    
}
- (void)changedAction:(UISlider *)slder{
    CGFloat brightness = slder.value;
    [[UIScreen mainScreen] setBrightness:brightness];
}
- (void)outsideAction:(UISlider *)slder{
//    NSInteger brightness = slder.value;
//    NSLog(@"%@",@(brightness));
//    if ([self.delegate respondsToSelector:@selector(readSetView:chapter:)]) {
//        [self.delegate readSetView:self chapter:brightness];
//    }
}
- (void)segmentAction:(UISegmentedControl *)sender{
    [GKSetManager setBrowseState:sender.selectedSegmentIndex];
    if ([self.delegate respondsToSelector:@selector(readSetView:browState:)]) {
        [self.delegate readSetView:self browState:sender.selectedSegmentIndex];
    }
}
- (void)switchAction:(UISwitch *)sender{
     [GKSetManager setLandscape:sender.on];
    if ([self.delegate respondsToSelector:@selector(readSetView:screen:)]) {
        [self.delegate readSetView:self screen:sender.on];
    }
}
- (void)moreSetActon{
    if ([self.delegate respondsToSelector:@selector(readSetView:moreSet:)]) {
        [self.delegate readSetView:self moreSet:YES];
    }
}
- (IBAction)downAction:(UIButton *)sender {
    GKSet *model = [GKSetManager shareInstance].model;
    NSInteger font = model.font - 1;
    if (font < 10) {
        return;
    }
    if (font <= 10) {
        sender.backgroundColor = [UIColor colorWithRGB:0xdcdcdc];
    }else{
        sender.backgroundColor = Appxffffff;
        self.addBtn.backgroundColor = Appxffffff;
    }
    self.fontLab.text = [NSString stringWithFormat:@"%@ px",@(font)];
    [GKSetManager setFont:font];
    if ([self.delegate respondsToSelector:@selector(readSetView:font:)]) {
        [self.delegate readSetView:self font:font];
    }
}

- (IBAction)addAction:(UIButton *)sender {
    GKSet *model = [GKSetManager shareInstance].model;
    NSInteger font = model.font + 1;
    if (font > 30) {
        return;
    }
    if (font >=30) {
        sender.backgroundColor = [UIColor colorWithRGB:0xdcdcdc];
    }else{
        sender.backgroundColor = Appxffffff;
        self.downBtn.backgroundColor = Appxffffff;
    }
    self.fontLab.text = [NSString stringWithFormat:@"%@ px",@(font)];
    [GKSetManager setFont:font];
    if ([self.delegate respondsToSelector:@selector(readSetView:font:)]) {
        [self.delegate readSetView:self font:font];
    }
}
- (IBAction)scrowAction:(UIButton *)sender {
    [GKSetManager setBrowseState:GKBrowseDefault];
    if ([self.delegate respondsToSelector:@selector(readSetView:browState:)]) {
        [self.delegate readSetView:self browState:GKBrowseDefault];
    }
    [self changeButtonState];
}
- (IBAction)scralAction:(id)sender {
    [GKSetManager setBrowseState:GKBrowsePageCurl];
    if ([self.delegate respondsToSelector:@selector(readSetView:browState:)]) {
        [self.delegate readSetView:self browState:GKBrowsePageCurl];
    }
    [self changeButtonState];
}
- (IBAction)animaAction:(id)sender {
    [GKSetManager setBrowseState:GKBrowseVertical];
    if ([self.delegate respondsToSelector:@selector(readSetView:browState:)]) {
        [self.delegate readSetView:self browState:GKBrowseVertical];
    }
    [self changeButtonState];
}
- (void)changeButtonState{
    GKSet *model = [GKSetManager shareInstance].model;
    [self.buttonDatas enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 3;
        if (model.browseState == idx) {
            [obj setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
            [obj setTitleColor:Appxffffff forState:UIControlStateNormal];
        }else{
            [obj setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xeeeeee]] forState:UIControlStateNormal];
            [obj setTitleColor:Appx333333 forState:UIControlStateNormal];
        }
    }];
}
- (void)loadData{
    GKSet *model = [GKSetManager shareInstance].model;
    NSInteger font = model.font;
    self.fontLab.text = [NSString stringWithFormat:@"%@ px",@(font)];
    self.listData = [GKSetManager defaultSkinDatas];
    [self changeButtonState];
    [self.collectionView reloadData];
    
}

+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)circleImageWithName:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
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
    return CGSizeMake(50, 50);
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
    GKSkin *model = self.listData[indexPath.row];
    cell.imageV.image = [UIImage imageNamed:model.skin];
    cell.imageIcon.hidden = model.state != [GKSetManager shareInstance].model.state;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKSkin *model = self.listData[indexPath.row];
    if (model.state == [GKSetManager shareInstance].model.state) {
        return;
    }
    [GKSetManager setReadState:model.state];
    if ([self.delegate respondsToSelector:@selector(readSetView:state:)]) {
        [self.delegate readSetView:self state:model.state];
    }
    [self loadData];
}
@end
