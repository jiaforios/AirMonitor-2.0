//
//  NetDataManger.m
//  AirMonitor
//
//  Created by foscom on 16/12/13.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "NetDataManger.h"
#import "NetHelper.h"
#import "HistoryModel.h"
#import "MJExtension.h"
@interface NetDataManger ()
@property(nonatomic,copy)NSString *curentDate; // 当前的时间点
@property(nonatomic,copy)NSString *sevenDate; // 七天前的时间

@end

@implementation NetDataManger


+(instancetype)instanceResultDeviceId:(NSString *)deviceid Block:(void(^)(id))block
{
    NetDataManger *manger = [[NetDataManger alloc] init];
    [[NetHelper shareNetManger] getHostoryDataWithUrl:kHistoryBaseUrl withDeviceId:deviceid andStartTime:manger.sevenDate andEndTime:manger.curentDate andBackBlock:^(id value) {
        
        HistoryModel *hisModel = [HistoryModel mj_objectWithKeyValues:value];
        block?block(hisModel.data):nil;
    }];
    return manger;
}

+(instancetype)instanceResultDeviceId:(NSString *)deviceid
                         andStartTime:(NSString *)stime andEndTime:(NSString *)etime
                                Block:(void(^)(id))block
{
    NetDataManger *manger = [[NetDataManger alloc] init];
    [[NetHelper shareNetManger] getHostoryDataWithUrl:kHistoryBaseUrl withDeviceId:deviceid andStartTime:stime andEndTime:etime andBackBlock:^(id value) {
        
        HistoryModel *hisModel = [HistoryModel mj_objectWithKeyValues:value];
        block?block(hisModel.data):nil;
    }];
    return manger;
}


- (instancetype)init
{
    if (self = [super init]) {
        [self currentDater];
    }
    return self;
}
- (void)currentDater
{
    NSCalendar *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [NSDateComponents new];
    NSDateComponents *comps1 = [NSDateComponents new];
    
    NSInteger unitFlags     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    
    NSDate * sevdata = [NSDate dateWithTimeIntervalSinceNow:-7*24*3600];
    
    comps                   = [calendar components:unitFlags fromDate:now];
    
    NSInteger  year         = [comps year];
    NSInteger  month        = [comps month];
    NSInteger day           = [comps day];
    NSInteger hour          = [comps hour];
    NSInteger min           = [comps minute];
    NSInteger second        = [comps second];
    
    comps1                   = [calendar components:unitFlags fromDate:sevdata];
    
    NSInteger  year1         = [comps1 year];
    NSInteger  month1        = [comps1 month];
    NSInteger day1           = [comps1 day];
    NSInteger hour1          = [comps1 hour];
    NSInteger min1           = [comps1 minute];
    NSInteger second1       = [comps1 second];
    
    // 当前时间点
    _curentDate       = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(unsigned long)year,(unsigned long)month,(unsigned long)day,(unsigned long)hour,min,(unsigned long)second];
    
    // 七天前时间点
    _sevenDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(unsigned long)year1,(unsigned long)month1,(unsigned long)day1,(unsigned long)hour1,(unsigned long)min1,(unsigned long)second1];
}

@end
