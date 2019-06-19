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
@property (strong, nonatomic) UIImageView *mainView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *selectLab;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger chapterIndex;
@property (strong, nonatomic)GKReadView *readView;
@end

@implementation GKReadViewController
- (void)dealloc{
    NSLog(@"%@ dealloc",self.class);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    
}
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title content:(NSAttributedString *)content{
    self.pageIndex = currentPage;
    self.chapterIndex = chapter;
    self.readView.content = content;
    self.selectLab.text = [NSString stringWithFormat:@"%@/%@",@(currentPage+1),@(totalPage)];
    self.titleLab.text = title ?:@"";
}

- (void)loadUI{
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView.superview);
    }];
    [self.mainView addSubview:self.readView];
    [self.mainView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLab.superview);
        make.top.equalTo(self.titleLab.superview).offset(STATUS_BAR_HIGHT);
    }];
    [self.mainView addSubview:self.selectLab];
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
- (UIImageView *)mainView{
    if (!_mainView) {
        _mainView = [[UIImageView alloc] init];
        _mainView.userInteractionEnabled = YES;
        _mainView.clipsToBounds = YES;
        _mainView.contentMode = UIViewContentModeScaleAspectFill;
        _mainView.image = [UIImage imageNamed:@"read_green"];
    }
    return _mainView;
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
