//
//  weekDayView.h
//  NVRFunction
//
//  Created by foscom on 16/9/28.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^weekDayBlock)(NSString *weekDay);
typedef void(^DeleteBlock)(NSString *);

typedef NS_ENUM(NSUInteger, STYLETYPE) {
    PRESET_TYPE,
    DIRECTION_TYPE,
    DEFAULT,
};

@interface weekDayView : UIView

+ (instancetype)shareDaysWith:(NSArray *)days ResultBlock:(weekDayBlock)dayBlock;


- (void)reloadViewWithArr:(NSArray *)arr;
@end
