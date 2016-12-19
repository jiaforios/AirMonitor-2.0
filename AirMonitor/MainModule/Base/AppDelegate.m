//
//  AppDelegate.m
//  AirMonitor
//
//  Created by foscom on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "AppDelegate.h"
#import "MZTabbarController.h"
#import <UMMobClick/MobClick.h>
#import "LoginViewController.h"
#define UMENG_APPKEY @"574936c0e0f55a83c1002c73" //while&2015 outlook.com

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self umengTrack];
    

  NSString *tiyan =  [[NSUserDefaults standardUserDefaults] objectForKey:@"tiYan"];
    
    NSString *account =  [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];

    if (![tiyan isEqualToString:@"titanOne"] && account) {
        MZTabbarController *tab = [[MZTabbarController alloc] init];
        self.window.rootViewController = tab;
    }else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        self.window.rootViewController = login;
    }
    
    
    
    
    // Override point for customization after application launch.
//    [[UMSocialManager defaultManager] openLog:YES];
//        [[UMSocialManager defaultManager] setUmSocialAppkey:@"574936c0e0f55a83c1002c73"];
    
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1105502764"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
//        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2026835151"  appSecret:@"6a269b581246b69cbe667caf526d7d17" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    

    
    return YES;
}

- (void)umengTrack {
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:appversion];
    
    [MobClick setLogEnabled:YES];
    
    UMConfigInstance.appKey = UMENG_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
