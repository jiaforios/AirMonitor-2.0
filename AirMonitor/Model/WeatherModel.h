//
//  WeatherModel.h
//  AirMonitor
//
//  Created by foscom on 16/12/13.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface update :NSObject
@property (nonatomic , copy) NSString              * loc;
@property (nonatomic , copy) NSString              * utc;

@end

@interface basic :NSObject
@property (nonatomic , copy) NSString              * cnty;
@property (nonatomic , copy) NSString              * wid;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * lon;
@property (nonatomic , strong) update              * update;

@end

@interface wind :NSObject
@property (nonatomic , copy) NSString              * dir;
@property (nonatomic , copy) NSString              * deg;
@property (nonatomic , copy) NSString              * sc;
@property (nonatomic , copy) NSString              * spd;

@end

@interface cond :NSObject
@property (nonatomic , copy) NSString              * txt;
@property (nonatomic , copy) NSString              * code;

@end

@interface now :NSObject
@property (nonatomic , copy) NSString              * pres;
@property (nonatomic , copy) NSString              * tmp;
@property (nonatomic , strong) wind              * wind;
@property (nonatomic , copy) NSString              * hum;
@property (nonatomic , copy) NSString              * vis;
@property (nonatomic , strong) cond              * cond;
@property (nonatomic , copy) NSString              * fl;
@property (nonatomic , copy) NSString              * pcpn;

@end

@interface HeWeather5 :NSObject
@property (nonatomic , strong) basic              * basic;
@property (nonatomic , strong) now              * now;
@property (nonatomic , copy) NSString              * status;

@end

@interface WeatherModel :NSObject
@property (nonatomic , strong) NSArray              * HeWeather5;

@end
