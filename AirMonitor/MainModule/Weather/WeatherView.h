//
//  WeatherView.h
//  AirMonitor
//
//  Created by foscom on 16/12/13.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UILabel *loacation;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *direct;

@property (weak, nonatomic) IBOutlet UIButton *more;
- (instancetype)initWithFrame:(CGRect)frame andresultBlock:(void(^)())block;

@end
