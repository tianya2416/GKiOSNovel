//
//  UIImageView+GKLoad.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "UIImageView+GKLoad.h"

@implementation UIImageView (GKLoad)
- (void)setGkImageWithURL:(nullable NSString *)url{
    [self setGkImageWithURL:url placeholder:[UIImage imageWithColor:[UIColor colorWithRGB:0xf6f6f6]]];
}
- (void)setGkImageWithURL:(nullable NSString *)url
            placeholder:(nullable UIImage  *)placeholder{
    
    [self setGkImageWithURL:url unencode:YES placeholder:placeholder];
}
- (void)setGkImageWithURL:(nullable NSString *)url
                 unencode:(BOOL)unencode
              placeholder:(nullable UIImage *)placeholder{
    if ([url hasPrefix:@"/agent/"]) {
        url = [url stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }
    url = unencode ? [url stringByURLDecode] : url;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}
- (void)downGkImageWithURL:(nullable NSString *)url
                  unencode:(BOOL)unencode
               placeholder:(nullable UIImage  *)placeholder
                 completed:(void(^)(UIImage * _Nullable image,BOOL success))completed{
    if ([url hasPrefix:@"/agent/"]) {
        url = [url stringByReplacingOccurrencesOfString:@"agent/" withString:@""];
    }
    url = unencode ? [url stringByURLDecode] : url;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageFromCacheOnly progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        !completed ?: completed(image,error ? NO :YES);
    }];
}
@end
