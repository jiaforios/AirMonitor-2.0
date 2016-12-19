//
//  CommonAlert.h
//  FOSCAM_NVR
//
//  Created by foscom on 16/3/24.
//  Copyright © 2016年 foscam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAlert : UIView
typedef void (^GxqLeftBlock)();
typedef void (^GxqRightBlock)();
@property (nonatomic,copy)GxqLeftBlock leftBlock;
@property (nonatomic,copy)GxqRightBlock rightBlock;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger seconds;
@property (nonatomic,strong)UILabel *timeLabel;

- (void)appUpdateIn:(UIViewController *)vc;

@end
