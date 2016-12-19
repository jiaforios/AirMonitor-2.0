//
//  LoginViewController.m
//  AirMonitor
//
//  Created by foscom on 16/12/17.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+ImageEffects.h"
#import "weekDayView.h"
#import "MZTabbarController.h"
#import "XHToast.h"
#import "HUDManger.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.palceBtn.layer.borderWidth = 1;
    self.palceBtn.layer.cornerRadius = 5;
    self.palceBtn.layer.borderColor = [UIColor whiteColor].CGColor;

    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;

    self.devicelLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.devicelLabel.layer.borderWidth = 1;
    self.devicelLabel.layer.cornerRadius = 5;
//    self.devicelLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    self.devicelLabel.leftViewMode = UITextFieldViewModeAlways;
    
    self.devicelLabel.textAlignment = NSTextAlignmentCenter;
    [self.devicelLabel setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.devicelLabel setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIImage *sourceImage = [UIImage imageNamed:@"Default_iphone6.png"];
    UIImage *lastImage = [sourceImage applyLightEffect];//一句代码搞定毛玻璃效果
    self.backImage.image = lastImage;

    self.backImage.userInteractionEnabled = YES;
    
    
}
- (IBAction)placeAction:(id)sender {

    [weekDayView shareDaysWith:@[@"曲江区",@"高新区",@"未央区",@"雁塔区",@"新城区"] ResultBlock:^(NSString *weekDay) {
        
        [_palceBtn setTitle:weekDay forState:UIControlStateNormal];
    }];
    
}

- (IBAction)tiYanAction:(id)sender {
    
    
    [HUDManger shareHudManger].showAnimate(YES,3);
    [HUDManger shareHudManger].labelTextStr(@"请稍等...");
    [[NSUserDefaults standardUserDefaults] setObject:@"50026" forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setObject:@"titanOne" forKey:@"tiYan"];
    [[NSUserDefaults standardUserDefaults] setObject:_palceBtn.titleLabel.text forKey:@"place"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MZTabbarController *tab = [[MZTabbarController alloc] init];
        [self presentViewController:tab animated:YES completion:nil];
    });
}


- (IBAction)logInAction:(id)sender {
    
    if ([self chectError] == NO) {
        return;
    }
    [HUDManger shareHudManger].showAnimate(YES,3);
    [HUDManger shareHudManger].labelTextStr(@"请稍等...");
    [[NSUserDefaults standardUserDefaults] setObject:_devicelLabel.text forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setObject:@"titannil" forKey:@"tiYan"];
    [[NSUserDefaults standardUserDefaults] setObject:_palceBtn.titleLabel.text forKey:@"place"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MZTabbarController *tab = [[MZTabbarController alloc] init];
        [self presentViewController:tab animated:YES completion:nil];
    });

    
    
}

- (BOOL)chectError
{
    if (_devicelLabel.text.length == 0) {
        [self shakeAction:_devicelLabel];
        [XHToast showRemainContent:MZLocalizedString(@"inputDeviceId") hiddenTime:2];

        return NO;
    }
    if ([_palceBtn.titleLabel.text isEqualToString:@"选择区域"]) {
        [self shakeAction:_palceBtn];
        [XHToast showRemainContent:MZLocalizedString(@"chosePlace") hiddenTime:2];

        return NO;
    }

    return YES;
}

- (IBAction)tapAction:(id)sender {
    
    [self.view endEditing:YES];
    
}
- (void)shakeAction:(UIView *)sender
{
    
    CGPoint base = sender.layer.position;
    CAKeyframeAnimation *keys = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keys.values = @[valuePoint(base.x-8, base.y),valuePoint(base.x+8, base.y),
                    valuePoint(base.x-5, base.y),valuePoint(base.x+5, base.y),
                    valuePoint(base.x-3, base.y),valuePoint(base.x+3, base.y)];
    keys.duration = 0.5;
    [sender.layer addAnimation:keys forKey:@"shade"];
    
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
