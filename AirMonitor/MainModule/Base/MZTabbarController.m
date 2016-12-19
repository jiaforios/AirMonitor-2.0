//
//  MZTabbarController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "MZTabbarController.h"
#import "MZNavgationController.h"
extern NSString *currentViewPalce;

@interface MZTabbarController ()

@end

@implementation MZTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dealTabBarView];
}

// 配置基础组成
- (void)dealTabBarView
{
    
    [[UITabBar appearance] setBarTintColor:black_color];
    [[UITabBar appearance] setTranslucent:NO];
    
    NSArray <NSString *>*clsArr = @[@"RealTimeViewController",
                                    @"HistoryViewController",
                                    @"KnowledgeViewController",
                                    @"MoreViewController"];
    
    
    NSArray *tabArr =  @[MZLocalizedString(@"tab_realtime"),
                      MZLocalizedString(@"tab_history"),
                      MZLocalizedString(@"tab_knowledge"),
                      MZLocalizedString(@"tab_more")];
    NSArray *imgArr = @[@"shishi",@"his",@"zhishi",@"more"];
    NSMutableArray *mArr = [NSMutableArray new];
    [clsArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [mArr addObject:[self NavWithClassName:obj withTabBarName:tabArr[idx] andTabBarNorImage:[UIImage imageNamed:imgArr[idx]] andSelectedImage:nil]];
    }];
    
    self.viewControllers = [mArr copy];
}


- (MZNavgationController *)NavWithClassName:(NSString *)clsName
                             withTabBarName:(NSString *)tabbarName andTabBarNorImage:(UIImage *)norImage andSelectedImage:(UIImage *)selectImage
{
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [cls new];
    if (![tabbarName isEqualToString:MZLocalizedString(@"tab_realtime")]) {
        vc.title = tabbarName;
    }
    MZNavgationController *nav = [[MZNavgationController alloc] initWithRootViewController:vc];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:tabbarName image:norImage tag:0];
    [barItem setSelectedImage:selectImage];
    nav.tabBarItem = barItem;
    
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(5, 175, 235)} forState:UIControlStateSelected];  // 设置字体的选中颜色

    return nav;
    
}
// 在这个位置实现通知，加一个控制横屏的变量，在需要的位置发通知修改此处的实现
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    if ([currentViewPalce isEqualToString:@"historyVC"]) {
        
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
