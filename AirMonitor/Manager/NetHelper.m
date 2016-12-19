
//  NetHelper.m
//  AirMonitor
//
//  Created by foscom on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "NetHelper.h"
@interface NetHelper ()
@property(nonatomic,strong)AFHTTPSessionManager *sessionManger;

@end

static NetHelper *manger;

@implementation NetHelper

+(instancetype)shareNetManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[NetHelper alloc] init];
    });
    
    return manger;
}

-(instancetype)init
{
    if (self = [super init]) {
        
        _sessionManger = [AFHTTPSessionManager manager];
        _sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",nil];
    }
    
    return self;
}
- (void)getAirInformationWithUrl:(NSString *)url andDeviceId:(NSString *)deviceId andBackBlock:(void(^)(id))resultBlock
{
    
    NSString *urls = [NSString stringWithFormat:@"%@param={deviceId:%@}",url,deviceId];
    NSString *urlstr = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_sessionManger GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        resultBlock?resultBlock(dic[@"data"]):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",[error description]);

        resultBlock?resultBlock(NET_ERROR):nil;
    }];
    
}

- (void)getHostoryDataWithUrl:(NSString *)url withDeviceId:(NSString *)deviceId andStartTime:(NSString *)sTime andEndTime:(NSString *)eTime andBackBlock:(void (^)(id))resultBlock
{
    
    NSString *urls = [NSString stringWithFormat:@"%@param={'deviceId':'%@','startDate':'%@','endDate':'%@'}",url,deviceId,sTime,eTime];
    
    NSString *urlstr = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_sessionManger GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        resultBlock?resultBlock(dic):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",[error description]);
        
        resultBlock?resultBlock(NET_ERROR):nil;
    }];

}

- (void)get_now_weatherInfoWithCity:(NSString *)city resultBlock:(void(^)(id))block
{
    
    
    NSString *urls = [NSString stringWithFormat:@"%@city=%@&key=b04da913530c43c18177e823d7861d39",kNowHeatherUrl,city];
    
    NSString *uirstr = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_sessionManger GET:uirstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block?block(responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",[error description]);
        block?block(NET_ERROR):nil;
        
    }];
    
}

- (void)get_calendarWithDate:(NSString *)dateStr resultBlock:(void(^)(id,id))block
{

    NSString *urls = [NSString stringWithFormat:@"%@date=%@&key=88f0f701d9403bed53ed53c5fbb169c7",kcalendarUrl,dateStr];
    [_sessionManger GET:urls parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSDictionary *dic2 = dic[@"result"];
            NSDictionary *dic3 = dic2[@"data"];
            NSString *desc = [NSString stringWithFormat:@"今天是%@ %@ 农历%@",dic3[@"date"],dic3[@"weekday"],dic3[@"lunar"]];
            block?block(desc,dic2):nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",[error description]);
        block?block(NET_ERROR,NET_ERROR):nil;
    }];
    
}
- (void)requestAPPVersionWithUrlstring:(NSString *)urlString withBlock:(void (^)(id))datablock

{
    
    [_sessionManger GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            datablock((NSDictionary *)responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",[error description]);
        datablock?datablock(NET_ERROR):nil;
    }];

    
}




@end






