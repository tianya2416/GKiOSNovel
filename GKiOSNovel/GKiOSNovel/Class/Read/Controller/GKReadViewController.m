//
//  GKReadViewController.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKReadViewController.h"
#import "GKReadView.h"
@interface GKReadViewController ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *selectLab;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger chapterIndex;
@property (strong, nonatomic)GKReadView *readView;
@end

@implementation GKReadViewController
- (void)dealloc{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self loadUI];
    [self loadData];
    
}
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title content:(NSAttributedString *)content{
    self.pageIndex = currentPage;
    self.chapterIndex = chapter;
    self.readView.content = content;
    self.titleLab.text = title ;
    currentPage = currentPage + 1 >totalPage ? totalPage : currentPage + 1;
    self.selectLab.text = [NSString stringWithFormat:@"%@/%@",@(currentPage),@(totalPage)];
    self.selectLab.textColor = [GKReadSetManager shareInstance].model.color;
    self.titleLab.textColor = [GKReadSetManager shareInstance].model.color;
}

- (void)loadUI{

    [self.view addSubview:self.readView];
    [self.view addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLab.superview);
        make.top.equalTo(self.titleLab.superview).offset(STATUS_BAR_HIGHT);
    }];
    [self.view addSubview:self.selectLab];
    [self.selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLab.superview).offset(-15);
        make.bottom.equalTo(self.selectLab.superview).offset(-TAB_BAR_ADDING-10);
    }];
}
- (void)loadData{

}
- (GKReadView *)readView{
    if (!_readView) {
        _readView = [[GKReadView alloc] initWithFrame:AppReadContent];
        _readView.backgroundColor = [UIColor clearColor];
    }
    return _readView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = Appx666666;
        _titleLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    return _titleLab;
}
- (UILabel *)selectLab{
    if (!_selectLab) {
        _selectLab = [[UILabel alloc] init];
        _selectLab.textAlignment = NSTextAlignmentCenter;
        _selectLab.textColor = Appx999999;
        _selectLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _selectLab;
}
@end
