//
//  PieView.h
//  AirMonitor
//
//  Created by zengjia on 16/12/11.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

-(instancetype)intancesFrom:(CGRect)frame;
-(void(^)(int))changeWithDateValue;


@end
