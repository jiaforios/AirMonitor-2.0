
//
//  RealTimeViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "RealTimeViewController.h"
#import "PieView.h"
#import "UIColor+DataValue.h"
#import "Real_history_View.h"
#import "NetHelper.h"
#import "MJExtension.h"
#import "RealDataModel.h"
#import "WeatherView.h"
#import "MAPaoMaView.h"
#import "LCLoadingHUD.h"
#import "CommonAlert.h"
#import "ScreenShotsManager.h"
#import "CalendView.h"
@interface RealTimeViewController ()<UIScrollViewDelegate>
{
    MAPaoMaView *paoma;
    UIButton * shareBtn;
    UIView *filpView;
    WeatherView *wview;
}
@property(nonatomic,strong)Real_history_View *inView;
@property(nonatomic,strong)Real_history_View *outView;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UISegmentedControl *seg;
@property(nonatomic,strong)dispatch_group_t group;
@property (nonatomic, strong) UIImageView *screenShotsImageV;//截屏
@property (nonatomic, assign) CGFloat screenBrightness;//屏幕亮度
@property(nonatomic,strong)CalendView *calV;
@property(nonatomic,strong)NSDictionary *calDic;
@property(nonatomic,strong)NSTimer *missTimer; // 自动消失的timer
@property(nonatomic,strong)NSTimer *flipTimer;


@end

@implementation RealTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _group = dispatch_group_create();

    [self setUpNav];
    [self setUpView];
    [self flipWeatherView];
    [[[CommonAlert alloc] init] appUpdateIn:self];

    [self acquireCalenderData];
 
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        NSLog(@"全部信息请求成功");
        [LCLoadingHUD hideInView:self.view];
    });
    
    [self testjspatch]; //  测试热更新
    
}

- (void)setUpNav
{
    UIButton *screenShotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenShotsBtn.frame = CGRectMake(0, 0, 32, 32);
    [screenShotsBtn setImage:[UIImage imageNamed:@"ScreenShots"] forState:UIControlStateNormal];
    [screenShotsBtn addTarget:self action:@selector(screenShotsAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenShotsBtn];
    
}

- (void)setUpView
{
    
    NSString *deviceid = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT)];
    _scrollview.contentSize = CGSizeMake(MZ_WIDTH *2, MZ_HEIGHT);
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    _inView = [[Real_history_View alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT-49) withId:deviceid];
    
    _outView = [[Real_history_View alloc] initWithFrame:CGRectMake(MZ_WIDTH, 0, MZ_WIDTH, MZ_HEIGHT-49) withId:OUTDEV];
    
    [_scrollview addSubview:_inView];
    [_scrollview addSubview:_outView];
    
    
    [self.view addSubview:_scrollview];
    _seg = [[UISegmentedControl alloc] initWithItems:@[MZLocalizedString(@"real_inside"),MZLocalizedString(@"real_outside")]];
    
    _seg.frame = CGRectMake(0, 0, 100, 25);
    [_seg setSelectedSegmentIndex:0];
    
    [_seg setTintColor:[UIColor whiteColor]];
    [_seg setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:0];
    [_seg addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _seg;
    
}


- (void)acquireCalenderData
{
    dispatch_group_enter(_group);

    [[NetHelper shareNetManger] get_calendarWithDate:[self acquireDateTime] resultBlock:^(id dataValue,id allValue) {
        if ([dataValue isEqualToString:NET_ERROR]) {
            return ;
        }
        _calDic = allValue;
        NSLog(@"日历信息请求成功allvalue = %@",allValue);
        [_calV dealWithCalData:allValue];
//         paoma = [[MAPaoMaView alloc]initWithFrame:CGRectMake((MZ_WIDTH-200)/2.0, 0, 200, 30) withTitle:dataValue];
//        [paoma start];
//        [self.view addSubview:paoma];
        dispatch_group_leave(_group);

    }];
    
    
}

- (void)testjspatch
{
    NSLog(@"123333");
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [paoma stop];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [paoma start];
//
//}


- (void)flipWeatherView
{
    
    filpView = [[UIView alloc] initWithFrame:CGRectMake(MZ_WIDTH-177, MZ_HEIGHT-64-49-188, 170, 188)];
    filpView.layer.cornerRadius = 5;
    filpView.backgroundColor = [UIColor clearColor];
    [LCLoadingHUD showLoading:@"" inView:self.view];
    dispatch_group_enter(_group);
    

    wview = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, 170, 188) andresultBlock:^{
        dispatch_group_leave(_group);
        
    }];
    [filpView addSubview:wview];
    [self.view addSubview:filpView];
    
    //    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftbtn.frame = CGRectMake(0, 0, 30, 100);
    //    leftbtn.titleLabel.numberOfLines = 0;
    //    leftbtn.titleLabel.font = font_15;
    //    leftbtn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    //    [leftbtn setTitle:@"今\n日\n天\n气" forState:UIControlStateNormal];
    //    [leftbtn addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [filpView addSubview:leftbtn];
    
    
    // 设置天气小界面自动翻转
    
     _calV = [[CalendView alloc] initWithFrame:CGRectMake(0, 20, 170, 150)];
    
    
    _flipTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(filpAction) userInfo:nil repeats:YES];

}

- (void)filpAction
{
    static BOOL filp = NO;
    filp = !filp;
    if (filp) {
        [UIView transitionWithView:filpView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [wview removeFromSuperview];
            [filpView addSubview:_calV];
            
        } completion:nil];
    }else
    {
        [UIView transitionWithView:filpView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_calV removeFromSuperview];
            [filpView addSubview:wview];
        } completion:nil];
        
    }

}

-(void)changeSegment:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{

            [_scrollview setContentOffset:CGPointMake(0, 0)];
        }];
        
        
    }
   else if (seg.selectedSegmentIndex == 1) {
       
       [UIView animateWithDuration:0.25 animations:^{
           [_scrollview setContentOffset:CGPointMake(MZ_WIDTH, 0)];

       }];
    }
}
- (NSString *)acquireDateTime
{
    NSCalendar *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [NSDateComponents new];
    NSInteger unitFlags     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    
    comps                   = [calendar components:unitFlags fromDate:now];
    
    NSInteger  year         = [comps year];
    NSInteger  month        = [comps month];
    NSInteger day           = [comps day];
    NSString *str  = [NSString stringWithFormat:@"%ld-%ld-%ld",(unsigned long)year,(unsigned long)month,(unsigned long)day];
    NSLog(@"weekadat = %@",str);
    return str;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x !=0) {
    
        [_seg setSelectedSegmentIndex:1];
    }else
    {
        [_seg setSelectedSegmentIndex:0];

    }
}



- (void)shareImageAction
{
    NSLog(@"点击分享");
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[_screenShotsImageV.image] applicationActivities:nil];
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
    {
        NSLog(@"调用分享的应用id :%@", activityType);
        if (completed)
        {
            NSLog(@"分享成功!");
        }
        else
        {
            NSLog(@"分享失败!");
        }
    };
    activity.completionHandler = myBlock;
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        [self presentViewController:activity animated:YES completion:nil];
    }

}

// 分享按钮动画
- (void)shakeAction:(UIButton *)sender
{

    CGPoint base = sender.layer.position;
    CAKeyframeAnimation *keys = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keys.values = @[valuePoint(base.x-8, base.y),valuePoint(base.x+8, base.y),
                    valuePoint(base.x-5, base.y),valuePoint(base.x+5, base.y),
                    valuePoint(base.x-3, base.y),valuePoint(base.x+3, base.y)];
    keys.duration = 0.5;
    [sender.layer addAnimation:keys forKey:@"shade"];
    
}
#pragma mark - ScreenShots
- (void)screenShotsAction{
    
    UIImage *image = [[ScreenShotsManager shareManager] makeScreenShots:self.view];
    _screenShotsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MZ_WIDTH, MZ_HEIGHT)];
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(MZ_WIDTH-40-20, 200, 50, 50);
    [shareBtn addTarget:self action:@selector(shareImageAction) forControlEvents:UIControlEventTouchUpInside];
    _screenShotsImageV.image = image;
    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    [self.navigationController.view addSubview:_screenShotsImageV];
    
    [UIView animateWithDuration:0.8 animations:^{
        
        _screenShotsImageV.frame = CGRectMake(MZ_WIDTH-40, 280, 0, 0);
        _screenShotsImageV.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        shareBtn.enabled = NO;
            [self shakeAction:shareBtn];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            shareBtn.enabled = YES;
        });
    }];
    
    
    
    [self.view addSubview:shareBtn];
    
   _missTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(missView) userInfo:nil repeats:YES];
    
    
}

- (void)dealloc
{
    [_flipTimer invalidate];
}

- (void)missView
{
    [shareBtn removeFromSuperview];
    [_missTimer invalidate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
