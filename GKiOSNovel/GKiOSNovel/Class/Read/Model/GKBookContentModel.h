//
//  GKBookContentModel.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/18.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKBookContentModel : BaseModel

@property (copy, nonatomic) NSString *contentId;//id
@property (copy, nonatomic) NSString *title;//文章标题
@property (copy, nonatomic) NSString *content;//content简体
@property (copy, nonatomic) NSString *traditional;//content繁体
@property (copy, nonatomic) NSString *created;//创建时间
@property (copy, nonatomic) NSString *updated;//更新时间
@property (assign, nonatomic) BOOL isVip;//是否需要vip

@property (assign, nonatomic)NSInteger pageIndex;//当前第几页
@property (assign, nonatomic)NSInteger pageCount;//文章总共多少页

- (void)setContentPage;
- (NSAttributedString *)getContentAtt:(NSInteger)page;

@end


NS_ASSUME_NONNULL_END
