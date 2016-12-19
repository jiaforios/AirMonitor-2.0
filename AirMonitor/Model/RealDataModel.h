//
//  RealDataModel.h
//  AirMonitor
//
//  Created by foscom on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealDataModel : NSObject

@property(nonatomic,strong)NSString *co2;
@property(nonatomic,strong)NSString *dateTime;
@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)NSString *humidity;
@property(nonatomic,strong)NSString *rid;
@property(nonatomic,strong)NSString *methanal;
@property(nonatomic,strong)NSString *pm10;
@property(nonatomic,strong)NSString *pm2;
@property(nonatomic,strong)NSString *temperature;
@property(nonatomic,strong)NSString *tvoc;



@end
