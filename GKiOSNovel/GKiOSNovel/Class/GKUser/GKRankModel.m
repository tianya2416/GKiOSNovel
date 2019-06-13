//
//  GKRankModel.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKRankModel.h"

@implementation GKRankModel
//- (BOOL)select{
//    if ([self._id isEqualToString:@"54d42d92321052167dfb75e3"] ||
//        [self._id isEqualToString:@"5a6844aafc84c2b8efaa6b6e"] ||
//        [self._id isEqualToString:@"54d43437d47d13ff21cad58b"]||
//        [self._id isEqualToString:@"5a684551fc84c2b8efaab179"]) {
//        return YES;
//    }
//    return _select;
//}
@end

@implementation GKRankInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"listBoys" : GKRankModel.class,
             @"listGirls" : GKRankModel.class,
             @"epub" : GKRankModel.class,
             @"picture" : GKRankModel.class,
             };
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listBoys" : @"male",
             @"listGirls" : @"female"};
}
- (void)setState:(GKUserState)state{
    if (_state != state) {
        _state = state;
        self.listData = (_state == GKUserBoy) ? self.listBoys : self.listGirls;
    }
}
- (void)setListBoys:(NSArray<GKRankModel *> *)listBoys{
    NSArray *listData= [GKUserManager shareInstance].user.rankDatas;
    if (listData) {
        [listData enumerateObjectsUsingBlock:^(GKRankModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"_id IN%@",obj._id?:@""];
            GKRankModel *model  = [listBoys filteredArrayUsingPredicate:pre1].firstObject;
            model.select = YES;
        }];
    }
     _listBoys = listBoys;
}
- (void)setListGirls:(NSArray<GKRankModel *> *)listGirls{
    NSArray *listData= [GKUserManager shareInstance].user.rankDatas;
    if (listData) {
        [listData enumerateObjectsUsingBlock:^(GKRankModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"_id IN%@",obj._id?:@""];
            GKRankModel *model  = [listGirls filteredArrayUsingPredicate:pre1].firstObject;
            model.select = YES;
        }];
    }
    _listGirls = listGirls;
}
@end
