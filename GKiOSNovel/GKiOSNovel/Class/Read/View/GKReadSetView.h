//
//  GKReadSetView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKReadSetView;
NS_ASSUME_NONNULL_BEGIN
@protocol GKReadSetDelegate <NSObject>
@optional
- (void)readSetView:(GKReadSetView *__nullable)setView brightness:(CGFloat)brightness;
- (void)readSetView:(GKReadSetView *__nullable)setView font:(CGFloat)font;
- (void)readSetView:(GKReadSetView *__nullable)setView state:(GKSkinState)state;
- (void)readSetView:(GKReadSetView *__nullable)setView screen:(BOOL)screen;
- (void)readSetView:(GKReadSetView *__nullable)setView moreSet:(BOOL)moreSet;
- (void)readSetView:(GKReadSetView *__nullable)moreView browState:(GKBrowseState)browState;
@end
@interface GKReadSetView : UIView
@property (assign, nonatomic) id<GKReadSetDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UILabel *fontLab;

- (void)loadData;

+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (UIImage *)circleImageWithName:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
