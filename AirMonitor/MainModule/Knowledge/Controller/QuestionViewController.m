//
//  QuestionViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/19.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新风知识";
    self.navigationItem.hidesBackButton = YES;
    UIButton *screenShotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenShotsBtn.frame = CGRectMake(0, 0, 12, 20);
    [screenShotsBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [screenShotsBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenShotsBtn];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT)];
    backview.backgroundColor = black_color;
    [self.view addSubview:backview];
    
    UITextView *textv = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, MZ_WIDTH-20, MZ_HEIGHT)];
    textv.textAlignment = NSTextAlignmentCenter;
    textv.font = font_15;
    textv.textColor = [UIColor whiteColor];
    textv.backgroundColor = [UIColor clearColor];
    textv.editable = NO;
    [backview addSubview:textv];
    textv.text = self.content;
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
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
