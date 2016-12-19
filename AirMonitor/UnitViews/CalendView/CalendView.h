//
//  CalendView.h
//  AirMonitor
//
//  Created by foscom on 16/12/16.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendView : UIView
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalLabel;
@property (weak, nonatomic) IBOutlet UILabel *YangLabel;
@property (weak, nonatomic) IBOutlet UILabel *YinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nofitLabel;


- (void)dealWithCalData:(id)value;


@end
