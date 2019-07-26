//
//  BaseDownFont.m
//  GKiOSNovel
//
//  Created by wangws1990 on 2019/7/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDownFont.h"

@implementation BaseDownFont
+ (void)downFontName:(NSString *)fontName progress:(void(^)(CGFloat value))progress completion:(void (^)(NSURL *filePath, NSError *error))completion
{
    UIFont* aFont = [UIFont fontWithName:fontName size:20];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        !completion?: completion(nil,nil);
    }
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [datas addObject:(__bridge id)desc];
    CFRelease(desc);
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)datas, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        dispatch_async( dispatch_get_main_queue(), ^ {
            if (state == kCTFontDescriptorMatchingDidBegin) {
                NSLog(@"开始匹配");
            } else if (state == kCTFontDescriptorMatchingDidFinish) {
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                NSString *url =  (__bridge NSString*)(fontURL);
                NSLog(@"%@",url);
                CFRelease(fontURL);
                CFRelease(fontRef);
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
                !completion ?: completion((NSURL *)url,nil);
            } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
                NSLog(@"Begin Downloading");
            } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
                NSLog(@"Finish downloading");
            } else if (state == kCTFontDescriptorMatchingDownloading) {
                CGFloat progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue]/100.0f;
                NSLog(@"Downloading %.0f%% complete", progressValue);
                !progress ?: progress(progressValue);
            } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
                NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                if (error) {
                    NSLog(@"%@",error.description);
                }
                !completion ?: completion(nil,error);
            }
        });
        return (bool)YES;
    });
}
@end
