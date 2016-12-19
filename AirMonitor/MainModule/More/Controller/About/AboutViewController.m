//
//  AboutViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property(nonatomic,strong)UIImageView *qrImage;
@property(nonatomic,strong)UILabel *appNameLabel;
@property(nonatomic,strong)UIButton *phoneBtn;
@property(nonatomic,strong)UILabel *copyright;


@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MZLocalizedString(@"联系商家");
    self.navigationItem.hidesBackButton = YES;
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT)];
    backview.backgroundColor = black_color;
    [self.view addSubview:backview];
    
    UIButton *screenShotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenShotsBtn.frame = CGRectMake(0, 0, 12, 20);
    [screenShotsBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [screenShotsBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenShotsBtn];
    
    
    
    [backview addSubview:self.appNameLabel];
    [backview addSubview:self.qrImage];
    [backview addSubview:self.phoneBtn];
    [backview addSubview:self.copyright];
    [self.qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
        make.center.equalTo(self.view);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.qrImage.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(320);
        
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.qrImage.mas_top).with.offset(-50);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(300);
    }];
    
    [self.copyright mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).with.offset(-10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(300);
    }];

    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UILabel *)copyright
{
    if (_copyright == nil) {
        _copyright = [[UILabel alloc] init];
        _copyright.textColor = white_color;
        _copyright.font = [UIFont systemFontOfSize:10];
        _copyright.text = MZLocalizedString(@"Copyright");
        _copyright.textAlignment = NSTextAlignmentCenter;
    }
    return _copyright;
}

- (UILabel *)appNameLabel
{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc] init];
        _appNameLabel.text = MZLocalizedString(@"appName");
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.font = font_17;
        _appNameLabel.numberOfLines = 0;
        _appNameLabel.textColor = white_color;
        
    }
    return _appNameLabel;
    
}

- (UIImageView *)qrImage
{
    if (_qrImage == nil) {
        _qrImage = [[UIImageView alloc] init];
        _qrImage.image = [UIImage imageNamed:@"qr"];
    }
    return _qrImage;
}

-(UIButton *)phoneBtn
{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] init];
        [_phoneBtn setTitle:MZLocalizedString(@"电话：029-89527321") forState:UIControlStateNormal];
        _phoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _phoneBtn.titleLabel.font = font_20;
        [_phoneBtn setTitleColor:white_color forState:UIControlStateNormal];
    }
    
    return _phoneBtn;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
