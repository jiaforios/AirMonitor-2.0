//
//  UIColor+DataValue.m
//  AirMonitor
//
//  Created by zengjia on 16/12/11.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "UIColor+DataValue.h"

@implementation UIColor (DataValue)

+ (UIColor *)colorWith_PM25_DataValue:(NSInteger)value
{
    if (value<=50) {
        return best_color;
    }else if (value<=100)
    {
        return well_color;
    }else if (value<=150)
    {
        return mild_pollution_color;
    }else if (value<=200)
    {
        return medium_pollution_color;
    }else if (value<=300)
    {
        return serious_pollution_color;
    }else
    {
        return baddly_pollution_color;
    }
    
}



@end
