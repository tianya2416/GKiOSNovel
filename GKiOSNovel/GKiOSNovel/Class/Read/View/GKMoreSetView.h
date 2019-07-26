//
//  GKMoreSetView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GKMoreSetView;

@protocol GKMoreSetDelegate <NSObject>

- (void)moreSetView:(GKMoreSetView *__nullable)moreView traditional:(BOOL)traditional;
- (void)moreSetView:(GKMoreSetView *__nullable)moreView fontName:(NSString *)fontName;
- (void)moreSetView:(GKMoreSetView *__nullable)moreView browState:(GKBrowseState)browState;
@end
@interface GKMoreSetView : UIView

@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) id<GKMoreSetDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
