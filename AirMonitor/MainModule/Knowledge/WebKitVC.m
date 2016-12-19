//
//  WebKitVC.m
//  AirMonitor
//
//  Created by foscom on 16/12/9.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "WebKitVC.h"
#import <WebKit/WebKit.h>
@interface WebKitVC ()
@property(nonatomic,strong)WKWebView *wkview;

@end

@implementation WebKitVC
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.urlTitle;
    self.navigationItem.hidesBackButton = YES;
    UIButton *screenShotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenShotsBtn.frame = CGRectMake(0, 0, 12, 20);
    [screenShotsBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [screenShotsBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenShotsBtn];
    
    self.wkview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT-64)];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSString *file = [[NSBundle mainBundle] pathForResource:_urlPath ofType:@"html"];

    NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
//    [self.wkview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:file]]];
    NSURL *urlpath = [NSURL fileURLWithPath:basePath isDirectory:YES];
    [self.wkview loadHTMLString:html baseURL:urlpath];

    [self.view addSubview:self.wkview];
    

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
