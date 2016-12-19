//
//  NetHelper.h
//  AirMonitor
//
//  Created by foscom on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface NetHelper : NSObject


+ (instancetype)shareNetManger;
- (void)getAirInformationWithUrl:(NSString *)url andDeviceId:(NSString *)deviceId andBackBlock:(void(^)(id))backData;
- (void)getHostoryDataWithUrl:(NSString *)url withDeviceId:(NSString *)deviceId andStartTime:(NSString *)sTime andEndTime:(NSString *)eTime andBackBlock:(void (^)(id))resultBlock;
- (void)get_now_weatherInfoWithCity:(NSString *)city resultBlock:(void(^)(id))block;
- (void)get_calendarWithDate:(NSString *)dateStr resultBlock:(void(^)(id,id))block;
- (void)requestAPPVersionWithUrlstring:(NSString *)urlString withBlock:(void (^)(id))datablock;

@end
