//
//  xValueFormat.m
//  AirMonitor
//
//  Created by foscom on 16/12/14.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "xValueFormat.h"

@implementation xValueFormat
{
    NSArray *timeArr;
    NSArray *dayArr;
    __weak LineChartView *_chart;

}

- (id)initForChart:(LineChartView *)chart WithTimeArr:(NSArray *)timeValue
{
    if (self = [super init]) {
        self->_chart = chart;
        timeArr = [timeValue copy];
      dayArr =  [self backDayFromTimeArr:timeArr];
    }
    return self;
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    
    if (timeArr.count<50) {
        // 单日
        
        NSMutableArray <NSString *>*mArr = [NSMutableArray new];
        [timeArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
                NSString *sr = [obj substringWithRange:NSMakeRange(11, obj.length-3-11)];
                [mArr addObject:sr];
        }];
        if (value>timeArr.count) {
            return @"";
        }
        if (!mArr.count) {
            return @"";
        }
        return mArr[(int)value];
        
    }else
    {
        NSMutableArray <NSString *>*mArr = [NSMutableArray new];
        [timeArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *sr = [obj substringWithRange:NSMakeRange(5, 5)];
            [mArr addObject:sr];
        }];
        if (value>timeArr.count) {
            return @"";
        }
        return mArr[(int)value];

    }

    return @"";
    
}

- (NSArray *)backDayFromTimeArr:(NSArray<NSString *> *)arr
{
    NSMutableSet *mset = [[NSMutableSet alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSString *day = [obj substringWithRange:NSMakeRange(5, 5)];
        [mset addObject:day];
    }];
    
    NSArray *tempArr = [mset allObjects];
    
   NSArray *sortArr =  [tempArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSLog(@"mset = %@",sortArr);

    return sortArr;
    
}

@end



