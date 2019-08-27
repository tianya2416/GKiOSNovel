//
//  GKReadBottomView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GKReadBottomView;;

@protocol GKReadBottomDelegate <NSObject>
@optional
- (void)bottomView:(GKReadBottomView *__nullable)bottomView day:(BOOL)day;
- (void)bottomView:(GKReadBottomView *__nullable)bottomView set:(BOOL)set;
- (void)bottomView:(GKReadBottomView *__nullable)bottomView cata:(BOOL)cata;
- (void)bottomView:(GKReadBottomView *__nullable)bottomView last:(BOOL)last;
- (void)bottomView:(GKReadBottomView *__nullable)bottomView page:(NSInteger)page;
@end
@interface GKReadBottomView : UIView
@property (weak, nonatomic) IBOutlet ATImageTopButton *dayBtn;
@property (weak, nonatomic) IBOutlet ATImageTopButton *setBtn;
@property (weak, nonatomic) IBOutlet ATImageTopButton *cataBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (assign, nonatomic) id <GKReadBottomDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
