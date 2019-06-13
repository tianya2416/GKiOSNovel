//
//  BaseModel.h
//  FDLive
//
//  Created by Linjw on 2017/1/6.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/NSObject+YYModel.h>

@interface BaseModel : NSObject <NSCoding, NSCopying,YYModel>

+ (NSData *)archivedDataForData:(id)data;
+ (id)unarchiveForData:(NSData*)data;

@end
