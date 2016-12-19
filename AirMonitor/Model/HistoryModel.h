//
//  HistoryModel.h
//  AirMonitor
//
//  Created by zengjia on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) NSArray              * data;
@property (nonatomic , strong) NSNumber              * code;

@end
//
//@interface data :NSObject
//
//@property (nonatomic , copy) NSString              * deviceId;
//@property (nonatomic , copy) NSString              * humidity;
//@property (nonatomic , copy) NSString              * methanal;
//@property (nonatomic , copy) NSString              * id;
//@property (nonatomic , copy) NSString              * pm2;
//@property (nonatomic , copy) NSString              * pm10;
//@property (nonatomic , copy) NSString              * temperature;
//@property (nonatomic , copy) NSString              * tvoc;
//@property (nonatomic , copy) NSString              * co2;
//@property (nonatomic , copy) NSString              * dateTime;
//
//@end
