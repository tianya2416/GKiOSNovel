//
//  BaseTableViewController.h
//  MyCountDownDay
//
//  Created by wangws1990 on 2019/1/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseRefreshController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (strong, nonatomic) UITableView *tableView;
@end
NS_ASSUME_NONNULL_END
