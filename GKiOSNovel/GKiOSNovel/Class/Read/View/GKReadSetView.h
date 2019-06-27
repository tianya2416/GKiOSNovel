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

- (void)readSetView:(GKReadSetView *)setView brightness:(CGFloat)brightness;
- (void)readSetView:(GKReadSetView *)setView font:(CGFloat)font;
- (void)readSetView:(GKReadSetView *)setView state:(GKReadState)state;
@end
@interface GKReadSetView : UIView
@property (assign, nonatomic) id<GKReadSetDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
