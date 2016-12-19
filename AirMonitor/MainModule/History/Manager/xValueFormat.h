//
//  xValueFormat.h
//  AirMonitor
//
//  Created by foscom on 16/12/14.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirMonitor-Bridging-Header.h"
@interface xValueFormat : NSObject<IChartAxisValueFormatter>

- (id)initForChart:(LineChartView *)chart WithTimeArr:(NSArray *)timeValue;



@end
