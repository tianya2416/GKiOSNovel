//
//  GKMoreSetView.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKMoreSetView.h"
#import "GKMoreSetCell.h"
#import "BaseDownFont.h"
@interface GKMoreSetView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) MBProgressHUD *hud;
@end
@implementation GKMoreSetView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.backgroundColor = Appx252631;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.switchBtn.onTintColor = AppColor;
    [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.backgroundColor = self.tableView.backgroundView.backgroundColor = Appx252631;
    
    self.segement.tintColor = AppColor;
    [self.segement setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [self.segement setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [self.segement addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self loadData];
}
- (void)loadData{
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    self.switchBtn.on = model.traditiona;
    
    self.segement.selectedSegmentIndex = model.browseState;
    
    self.listData = @[[BaseMacro fontName],@"PingFangSC-Regular",@"HelveticaNeue-Bold"];
    [self.tableView reloadData];
}
- (void)switchAction:(UISwitch *)sender{
    [GKReadSetManager setTraditiona:sender.on];
    if ([self.delegate respondsToSelector:@selector(moreSetView:traditional:)]) {
        [self.delegate moreSetView:self traditional:sender.on];
    }
}
- (void)segmentAction:(UISegmentedControl *)sender{
    [GKReadSetManager setBrowseState:sender.selectedSegmentIndex];
    if ([self.delegate respondsToSelector:@selector(moreSetView:browState:)]) {
        [self.delegate moreSetView:self browState:sender.selectedSegmentIndex];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKMoreSetCell *cell = [GKMoreSetCell cellForTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    NSString* fontName = self.listData[indexPath.row];
    cell.subTitleLab.text = fontName;
    cell.imageV.hidden = ![fontName isEqualToString:model.fontName];
    cell.titleLab.font = [UIFont fontWithName:fontName size:16];
    cell.titleLab.text = @"样本展示ABCDefgh";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* title = self.listData[indexPath.row];
    GKReadSetModel *model = [GKReadSetManager shareInstance].model;
    if ([title isEqualToString:model.fontName]) {
        return;
    }
    [GKReadSetManager setFontName:title];
    if ([self.delegate respondsToSelector:@selector(moreSetView:fontName:)]) {
        [self.delegate moreSetView:self fontName:title];
    }
    [self.tableView reloadData];

//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    [BaseDownFont downFontName:title progress:^(CGFloat progress) {
//        hud.progress = progress;
//    } completion:^(NSURL * _Nonnull filePath, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
//        if (!error) {
//            [GKReadSetManager setFontName:title];
//            if ([self.delegate respondsToSelector:@selector(moreSetView:fontName:)]) {
//                [self.delegate moreSetView:self fontName:title];
//            }
//        }else{
//            [MBProgressHUD showMessage:@"下载失败"];
//        }
//    }];

}
- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
    }
    return _hud;
}
@end
