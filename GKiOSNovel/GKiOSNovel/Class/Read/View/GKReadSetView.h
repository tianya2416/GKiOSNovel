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

- (void)readSetView:(GKReadSetView *__nullable)setView brightness:(CGFloat)brightness;
- (void)readSetView:(GKReadSetView *__nullable)setView font:(CGFloat)font;
- (void)readSetView:(GKReadSetView *__nullable)setView state:(GKReadThemeState)state;
- (void)readSetView:(GKReadSetView *__nullable)setView screen:(BOOL)screen;
- (void)readSetView:(GKReadSetView *__nullable)setView moreSet:(BOOL)moreSet;
@end
@interface GKReadSetView : UIView
@property (assign, nonatomic) id<GKReadSetDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreSet;


- (void)loadData;
@end

NS_ASSUME_NONNULL_END
