//
//  GKBookDetaiContentCell.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKBookDetaiContentCell.h"

@implementation GKBookDetaiContentCell
- (void)setModel:(GKBookDetailModel *)model{
    _model = model;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = 4;
    
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName :[ATRefresh colorWithRGB:0x333333],
                                 NSParagraphStyleAttributeName : paragraph};
    self.contentLab.attributedText = [[NSMutableAttributedString alloc] initWithString:[model.longIntro  stringByTrim]?:@""
                                                  attributes:attributes];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
