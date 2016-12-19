//
//  NetDataManger.h
//  AirMonitor
//
//  Created by foscom on 16/12/13.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetDataManger : NSObject

+(instancetype)instanceResultDeviceId:(NSString *)deviceid Block:(void(^)(id))block;
+(instancetype)instanceResultDeviceId:(NSString *)deviceid andStartTime:(NSString *)stime andEndTime:(NSString *)etime Block:(void(^)(id))block;




@end
