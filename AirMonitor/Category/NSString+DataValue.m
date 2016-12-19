//
//  NSString+DataValue.m
//  AirMonitor
//
//  Created by foscom on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "NSString+DataValue.h"

@implementation NSString (DataValue)
+ (NSString *)stringFromValue:(NSInteger)value
{
    if (value<=50) {
        return MZLocalizedString(@"real_best");
    }else if (value<=100)
    {
        return MZLocalizedString(@"real_well");
    }else if (value<=150)
    {
        return MZLocalizedString(@"real_middl");
    }else if (value<=200)
    {
        return MZLocalizedString(@"real_medium");
    }else if (value<=300)
    {
        return MZLocalizedString(@"real_serious");
    }else
    {
        return MZLocalizedString(@"real_baddly");
    }
}

@end

