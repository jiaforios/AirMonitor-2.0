//
//  MZNavgationController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "MZNavgationController.h"

@interface MZNavgationController ()

@end

@implementation MZNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[UINavigationBar appearance] setBarTintColor:black_color];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};

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
