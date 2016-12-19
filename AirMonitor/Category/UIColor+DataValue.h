//
//  UIColor+DataValue.h
//  AirMonitor
//
//  Created by zengjia on 16/12/11.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>
// 根据实时值返回正确的颜色
@interface UIColor (DataValue)

// 多接口易于扩展
+ (UIColor *)colorWith_PM25_DataValue:(NSInteger)value;

@end
