//
//  GKDownLoadCell.m
//  GKSeekSth
//
//  Created by wangws1990 on 2019/8/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDownLoadCell.h"

@implementation GKDownLoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 4;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = 1.5;
    self.downBtn.layer.masksToBounds = YES;
    self.downBtn.layer.cornerRadius = 12.5;
    self.downBtn.backgroundColor = AppColor;
    self.progressView.progressTintColor = AppColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(GKDownBookInfo *)info{
    if (_info != info) {
        _info = info;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:placeholders];
        self.titleLab.text = info.title ?:@"";
    }
    self.progress = info.downIndex;
    [self setUI];
}
- (void)setProgress:(NSInteger)progress{
    if (_progress != progress) {
        _progress = progress;
    }
    self.info.downIndex = progress;
    if (self.info.chapters.count > 0) {
        CGFloat pro = (float)progress/self.info.chapters.count;
        self.progressView.progress = pro;
        self.subTitleLab.text = [NSString stringWithFormat:@"%@/%@",@(progress),@(self.info.chapters.count)];
    }
}

- (void)setState:(GKDownTaskState)state{
    if (_state != state) {
        _state = state;
    }
    self.info.state = state;
    [self setUI];
}
- (void)setUI{
    NSString *title = @"等待中";
    switch (self.info.state) {
        case GKDownTaskDefault:
            title = @"等待中";
            break;
        case GKDownTaskPause:
            title =@"暂停中";
            break;
        case GKDownTaskLoading:
            title =@"下载中";
            break;
        case GKDownTaskFinish:
            title = @"下载完成";
            break;
        default:
            break;
    }
    self.downBtn.hidden = self.info.state == GKDownTaskFinish;
    [self.downBtn setTitle:title forState:UIControlStateNormal];
    self.stateLab.text = title ;
}
@end
