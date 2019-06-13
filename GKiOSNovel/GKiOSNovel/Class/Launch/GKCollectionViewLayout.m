//
//  YCollectionViewLayout.m
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/8.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "GKCollectionViewLayout.h"

@interface GKCollectionViewLayout ()

@property (assign, nonatomic) GKLayoutStyle style;
@property (strong, nonatomic) NSMutableArray *layoutAttrArr;

@property (assign, nonatomic) CGFloat maxHeight;

@end

@implementation GKCollectionViewLayout
+ (instancetype)vcWithStyle:(GKLayoutStyle)style{
    GKCollectionViewLayout *vc = [[GKCollectionViewLayout alloc] init];
    vc.style = style;
    return vc;
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.width, _maxHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    self.style == GKLayoutStyleTag ? [self setupTagViewLayout] : [self setupRecommendViewLayout];
}

- (void)setupTagViewLayout {
    self.layoutAttrArr = @[].mutableCopy;
    __block CGFloat x = self.minimumInteritemSpacing;
    __block CGFloat y = self.minimumLineSpacing;
    [self.dataArr enumerateObjectsUsingBlock:^(GKRankModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSString *tag = obj.shortTitle;
        CGSize size = [tag boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        size.width += 18;
        size.height += 5;
        if (x + size.width + self.minimumInteritemSpacing > self.collectionView.width) {
            x = self.minimumInteritemSpacing;
            y += size.height + self.minimumLineSpacing;
        }
        attr.frame = CGRectMake(x, y, size.width, size.height);
        x += attr.frame.size.width + self.minimumInteritemSpacing;
        self.maxHeight = y + size.height + self.minimumLineSpacing;
        [self.layoutAttrArr addObject:attr];
    }];
}

- (void)setupRecommendViewLayout {
    self.layoutAttrArr = @[].mutableCopy;
    [self.layoutAttrArr addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    self.headerReferenceSize = CGSizeMake(self.collectionView.width, 44);
    CGFloat ratio = 45/36.0;
    NSInteger maxBooks = kScreenWidth > 400 ? 5 : 4;
    CGFloat space = kScreenWidth > 350 ? 25 : 20;
    CGFloat width = (self.collectionView.width - (maxBooks + 1) * space) / maxBooks;
    CGFloat x = space;
    CGFloat y = self.headerReferenceSize.height;
    for (NSInteger i = 0; i < MIN(self.dataArr.count, maxBooks) ; i++) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSString *book = self.dataArr[i].shortTitle;
        CGSize size = [book boundingRectWithSize:CGSizeMake(width-2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
        size.height += width * ratio + 5;
        
        attr.frame = CGRectMake(x, y, width, size.height);
        x += attr.frame.size.width + space;
        if (y + size.height > self.maxHeight) {
            self.maxHeight = y + size.height;
        }
        [self.layoutAttrArr addObject:attr];
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.layoutAttrArr.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.frame = CGRectMake(0, 0, self.collectionView.width, 40);
    return attr;
}

@end
