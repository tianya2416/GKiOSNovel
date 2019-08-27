//
//  GKReadTopView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKReadTopView;
NS_ASSUME_NONNULL_BEGIN
@protocol GKReadTopDelegate <NSObject>
@optional
- (void)readTopView:(GKReadTopView *__nullable)setView goBack:(BOOL)goBack;
- (void)readTopView:(GKReadTopView *__nullable)setView native:(BOOL)native;
- (void)readTopView:(GKReadTopView *__nullable)setView down:(BOOL)down;
@end
@interface GKReadTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLab;

@property (assign, nonatomic) id<GKReadTopDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
