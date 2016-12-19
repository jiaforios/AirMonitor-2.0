//
//  HistoryLineView.h
//  AirMonitor
//
//  Created by zengjia on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryLineView : UIView

-(void)configDataWithTitle:(NSString *)title
                   InValue:(NSArray *)inValue
                 andInTime:(NSArray *)intime
               andOutValue:(NSArray *)outValue
                andOutTime:(NSArray *)outTime
               andTopValue:(NSInteger)topValue;

- (void)removeData;

@end
