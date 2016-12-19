//
//  CommonAlert.m
//  FOSCAM_NVR
//
//  Created by foscom on 16/3/24.
//  Copyright © 2016年 foscam. All rights reserved.
//

#import "CommonAlert.h"
#import "NetHelper.h"
#import "XHToast.h"
@implementation CommonAlert

- (void)appUpdateIn:(UIViewController *)vc
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [[NetHelper shareNetManger] requestAPPVersionWithUrlstring:APPVERSIONURL withBlock:^(id data) {
            
            if ([data isKindOfClass:[NSString class]]&&[data isEqualToString:NET_ERROR]) {
                
//                [XHToast showFailContent:@"" hiddenTime:2];
                return ;
            }
            
            NSArray *resultArr = data[@"results"];
            
            if (resultArr.count!=0) {
                
                NSDictionary *dic = resultArr[0];
                NSString *version = dic[@"version"];
                NSString *appUrl = dic[@"trackViewUrl"];
//            NSString *updateContent = dic[@"releaseNotes"];
                
                NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
                 
                if([localVersion compare:version] < 0)
                {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            UIAlertController *all = [UIAlertController alertControllerWithTitle:@"发现新版本" message:[NSString stringWithFormat:@"%@:%@",@"新版本",version] preferredStyle:UIAlertControllerStyleAlert];
                            
                            [all addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                             

                            }]];
                            
                            
                            [all addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];

                            }]];

                         [vc presentViewController:all animated:YES completion:nil];
                            
                            
                        });
                        
                    }
                    

                
                
            }
            
            
            
        }];
        
    });

    
    

    
}
- (void)showWithTipText:(NSString *)tipText descText:(NSString *)descText LeftText:(NSString *)leftText second:(NSInteger)seconds rightText:(NSString *)rightText LeftBlock:(GxqLeftBlock)leftBlock RightBlock:(GxqRightBlock)rightBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CommonAlert *selfView = [[CommonAlert alloc]initWithFrame:[UIScreen mainScreen].bounds];
    selfView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [keyWindow addSubview:selfView];
    //弹出框
    [selfView contentViewWithTipText:tipText descText:descText LeftText:leftText second:seconds rightText:rightText leftBlock:leftBlock RightBlock:rightBlock];
}

+ (void)dismiss
{
    
}

- (void)contentViewWithTipText:(NSString *)tipText descText:(NSString *)descText LeftText:(NSString *)leftText second:(NSInteger)seconds rightText:(NSString *)rightText leftBlock:(GxqLeftBlock)leftBlock RightBlock:(GxqRightBlock)rightBlock
{
    self.leftBlock = leftBlock;
    self.rightBlock = rightBlock;
    self.seconds = seconds + 1;
    CGFloat alertViewW = MZ_WIDTH * 0.68;
    CGFloat alertViewH = 140;
    UIView *alertView = [UIView new];
    
    alertView.alpha = 0;
    alertView.layer.cornerRadius = 8;
    alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25f animations:^{
        alertView.alpha = 1.0;
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    
    alertView.frame = CGRectMake((MZ_WIDTH - alertViewW) * 0.5, (MZ_HEIGHT - alertViewH) * 0.5, alertViewW, alertViewH);
    alertView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    [self addSubview:alertView];
    
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.frame = CGRectMake(0, 20, alertView.frame.size.width, 30);
    tipLabel.text = tipText;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    
    [alertView addSubview:tipLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.frame = CGRectMake(0, 50, alertView.frame.size.width, 30);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = descText;
    descLabel.font = [UIFont systemFontOfSize:14];
    [alertView addSubview:descLabel];
    
    UIView *lineHView = [UIView new];
    lineHView.frame = CGRectMake(0, 100, alertView.frame.size.width, 0.5);
    lineHView.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.87 alpha:1];
    [alertView addSubview:lineHView];
    
    UIView *lineVView = [UIView new];
    lineVView.frame = CGRectMake(alertView.frame.size.width * 0.5, CGRectGetMaxY(lineHView.frame), 0.5, alertView.frame.size.height -CGRectGetMaxY(lineHView.frame));
    lineVView.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.87 alpha:1];
    [alertView addSubview:lineVView];
    
    UILabel *cancelLabel = [[UILabel alloc]init];
    cancelLabel.frame = CGRectMake(20, 100, alertView.frame.size.width/4 + 10, 40);
    cancelLabel.text = leftText;
    cancelLabel.font = [UIFont systemFontOfSize:15];
    cancelLabel.textColor = [UIColor lightGrayColor];
    cancelLabel.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:cancelLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.frame = CGRectMake(alertView.frame.size.width/4 + 10, 115, self.frame.size.width / 4 - 5, 12);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor redColor];
    self.timeLabel = timeLabel;
    //timeLabel.text = [NSString stringWithFormat:@"(%zd%@)",1,@"s"];
    [alertView addSubview:timeLabel];
    
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnChange:) userInfo:nil repeats:YES];
    //    _timer = timer;
    //    [timer fire];
    
    UIButton *sureBtn = [UIButton new];
    sureBtn.frame = CGRectMake(alertView.frame.size.width/2 , 100, alertView.frame.size.width / 2, 40);
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:rightText forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:5/256. green:175/256. blue:235/256. alpha:1] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [alertView addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.frame = CGRectMake(0, 100, alertView.frame.size.width * 0.5, 40);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [alertView addSubview:cancelBtn];
}

- (void)sureBtnClick:(UIButton *)btn
{
    if (_rightBlock) {
                
        self.rightBlock();
    }
    [self closeView];
}

- (void)cancelBtnClick:(UIButton *)btn
{
    if (_leftBlock) {
        
        self.leftBlock();
    }
    [self closeView];
}

- (void)btnChange:(UIButton *)btn
{
    _seconds--;
    //    [_leftBtn setTitle:[NSString stringWithFormat:@"取消(%zds)",_seconds] forState:UIControlStateNormal];
    _timeLabel.text = [NSString stringWithFormat:@"(%zd%@)",_seconds,@"s"];
    if (_seconds == 0) {
        [_timer invalidate];
        [self closeView];
        self.leftBlock();

    }
}


-(void)closeView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.subviews objectAtIndex:0].alpha = 0;
        [self.subviews objectAtIndex:0].transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
