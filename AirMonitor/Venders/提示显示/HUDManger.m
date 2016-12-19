//
//  HUDManger.m
//  FOSCAM_NVR
//
//  Created by foscom on 16/11/9.
//  Copyright © 2016年 foscam. All rights reserved.
//

#import "HUDManger.h"
#import "MBProgressHUD.h"
@interface HUDManger ()
@property(nonatomic,strong)UIWindow *hwindow;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

static HUDManger *manger = nil;

@implementation HUDManger


+ (instancetype)shareHudManger
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manger = [[self alloc] init];
        manger.hud = [[MBProgressHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
        manger.hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        manger.hwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        manger.hwindow.windowLevel = UIWindowLevelAlert;
        manger.hud.bezelView.backgroundColor = [black_color colorWithAlphaComponent:0.5];
        [manger.hwindow addSubview:manger.hud];
        [manger.hwindow becomeKeyWindow];
        [manger.hwindow makeKeyAndVisible];
        
    });
    if (!manger.hwindow) {
        manger.hwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

        [manger.hwindow addSubview:manger.hud];
    }
    return manger;
}

- (HUDManger *(^)(BOOL,NSUInteger))showAnimate
{
    
    return ^(BOOL show,NSUInteger timeout){
    
        if (show) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [manger.hud showAnimated:YES ];
                [manger.hud hideAnimated:YES afterDelay:timeout];
                manger.hud.completionBlock = ^{
                    [manger.hwindow resignKeyWindow];
                    manger.hwindow = nil;
                    [[UIApplication sharedApplication].delegate.window becomeKeyWindow];
                    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];

                };
                [manger.hwindow becomeKeyWindow];
                [manger.hwindow makeKeyAndVisible];
            });

        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hideAnimated:YES afterDelay:timeout];
                _hud.completionBlock = ^{
                    [manger.hwindow resignKeyWindow];
                    [[UIApplication sharedApplication].delegate.window becomeKeyWindow];
                    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                    manger.hwindow = nil;
                };
                
            });

        }
        
        return self;
    };
}

- (HUDManger *(^)(NSString *))labelTextStr
{

    return ^(NSString *text){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            manger.hud.label.text = text;
        });
        
        return self;
    };
    
}

@end
