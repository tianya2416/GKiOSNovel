//
//  GKSearchTopView.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/9/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKSearchTopView;
NS_ASSUME_NONNULL_BEGIN
@protocol GKSearchTopDelegate <NSObject>

- (void)searchTopView:(GKSearchTopView *)topView keyword:(NSString *)keyword;
- (void)searchTopView:(GKSearchTopView *)topView goback:(BOOL)goback;

@end
@interface GKSearchTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (assign, nonatomic) id<GKSearchTopDelegate>delegate;
@property (copy, nonatomic) NSString *keyword;
@end

NS_ASSUME_NONNULL_END
