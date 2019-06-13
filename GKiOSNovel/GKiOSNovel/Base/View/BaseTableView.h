//
//  BaseTableView.h
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseView.h"

@interface BaseTableView : BaseView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@end
