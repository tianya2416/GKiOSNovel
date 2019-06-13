//
//  UIImageView+GKLoad.h
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/6/12.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (GKLoad)

- (void)setGkImageWithURL:(nullable NSString *)url;
- (void)setGkImageWithURL:(nullable NSString *)url
              placeholder:(nullable UIImage  *)placeholder;
- (void)setGkImageWithURL:(nullable NSString *)url
                 unencode:(BOOL)unencode
              placeholder:(nullable UIImage  *)placeholder;

- (void)downGkImageWithURL:(nullable NSString *)url
                  unencode:(BOOL)unencode
               placeholder:(nullable UIImage  *)placeholder
                 completed:(void(^)(UIImage * _Nullable image,BOOL success))completed;
@end

NS_ASSUME_NONNULL_END
