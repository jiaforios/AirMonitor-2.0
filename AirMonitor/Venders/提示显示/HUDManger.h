//
//  HUDManger.h
//  FOSCAM_NVR
//
//  Created by foscom on 16/11/9.
//  Copyright © 2016年 foscam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDManger : NSObject

+ (instancetype)shareHudManger;
- (HUDManger *(^)(BOOL,NSUInteger))showAnimate;
- (HUDManger *(^)(NSString *))labelTextStr;

@end
