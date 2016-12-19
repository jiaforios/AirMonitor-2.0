//
//  HistoryViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "HistoryViewController.h"
#import "RealDataModel.h"
#import "NetDataManger.h"
#import "HistoryLineView.h"
#import "YBPopupMenu.h"
#import "weekDayView.h"
#import "LCLoadingHUD.h"
#import "ScreenShotsManager.h"

NSString *currentViewPalce;


@interface HistoryViewController ()<YBPopupMenuDelegate>
@property(nonatomic,strong)NSMutableArray *paramArr;
@property(nonatomic,strong)NSMutableArray <RealDataModel *>*outFactorArr;
@property(nonatomic,strong)NSMutableArray <RealDataModel *>*inFactorArr;
@property(nonatomic,strong)NSArray *dayArr;
@property(nonatomic,strong)HistoryLineView *hisLine;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,strong)UIButton *sigDay;
@property(nonatomic,strong)UIButton *sevenBtn;
@property(nonatomic,copy)NSString *selectFactor; // 选中的空气因素
@property(nonatomic,assign)NSInteger topValue; // y轴最大值 默认值是PM2.5： 500
@property (nonatomic, strong) UIImageView *screenShotsImageV;//截屏

@end

@implementation HistoryViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    currentViewPalce = @"leavehistoryVC";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentViewPalce = @"historyVC";
}

-(NSMutableArray *)paramArr
{
    if (_paramArr == nil) {
        _paramArr = [NSMutableArray new];
        [_paramArr addObject:MZLocalizedString(@"PM25_his")];
        [_paramArr addObject:MZLocalizedString(@"PM10_his")];
        [_paramArr addObject:MZLocalizedString(@"CO2_his")];
        [_paramArr addObject:MZLocalizedString(@"HCHO_his")];
    }
    
    return _paramArr;
}
-(NSMutableArray *)outFactorArr
{
    if (_outFactorArr == nil) {
        
        _outFactorArr = [NSMutableArray new];
    }
    
    return _outFactorArr;
}
-(NSMutableArray *)inFactorArr
{
    if (_inFactorArr == nil) {
        
        _inFactorArr = [NSMutableArray new];
    }
    
    return _inFactorArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self currentDater];
    _selectFactor = @"pm2";
    _topValue = 500;
    [self setUpNav];
     _sevenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sevenBtn.layer.cornerRadius = 5;
    _sevenBtn.layer.borderWidth = 1;
    _sevenBtn.clipsToBounds = YES;
    _sevenBtn.titleLabel.font = font_15;
    _sevenBtn.selected = YES;
    _sevenBtn.layer.borderColor = RGBCOLOR(5, 175, 235).CGColor;
    [_sevenBtn setTitleColor:RGBCOLOR(5, 175, 235) forState:UIControlStateNormal];
    [_sevenBtn setTitle:@"七日历史趋势" forState:UIControlStateNormal];
    [_sevenBtn addTarget:self action:@selector(showSevenHistory:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_sevenBtn];
    
    _sigDay = [UIButton buttonWithType:UIButtonTypeCustom];
    _sigDay.layer.cornerRadius = 5;
    _sigDay.layer.borderWidth = 1;
    _sigDay.layer.borderColor = white_color.CGColor;
    _sigDay.clipsToBounds = YES;
    _sigDay.titleLabel.font = font_15;
    [_sigDay setTitle:@"单日历史趋势" forState:UIControlStateNormal];
    [_sigDay addTarget:self action:@selector(showSingleHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_sigDay];
    [_sevenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.view).with.offset(50);
        
    }];

    
    [_sigDay mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.view).with.offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.view).with.offset(50);
        
    }];
    
    
//     _hisLine = [[HistoryLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_sigDay.frame)+30, MZ_WIDTH-20, MZ_HEIGHT-(CGRectGetMaxY(_sigDay.frame)+30) -49-64)];

    _hisLine = [[HistoryLineView alloc] init];

    
    [self.view addSubview:_hisLine];

    [_hisLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(_sigDay.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).with.offset(-20);
        
    }];

    [self acquireHistoryDataWithStime:_startTime andeTime:_endTime factor:_selectFactor];
    
}
- (void)setUpNav
{
    UIButton *screenShotsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenShotsBtn.frame = CGRectMake(0, 0, 32, 32);
    [screenShotsBtn setImage:[UIImage imageNamed:@"ScreenShots"] forState:UIControlStateNormal];
    [screenShotsBtn addTarget:self action:@selector(screenShotsAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:screenShotsBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    

}

#pragma mark - ScreenShots
- (void)screenShotsAction{
    
    UIImage *image = [[ScreenShotsManager shareManager] makeScreenShots:self.view];
    _screenShotsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MZ_WIDTH, MZ_HEIGHT)];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        [shareBtn removeFromSuperview];
        [timer invalidate];
        
    }];
    
    
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


- (void)shareImageAction
{
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

- (void)acquireHistoryDataWithStime:(NSString *)stime andeTime:(NSString *)etime factor:(NSString *)facto
{
    
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    [LCLoadingHUD showLoading:@"" inView:self.view];

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [NetDataManger instanceResultDeviceId:deviceId andStartTime:stime andEndTime:etime Block:^(id dataValue) {
        
        NSLog(@"室内请求结束");
        // 返回的是realDataModel 数组
        _inFactorArr = [dataValue mutableCopy];
        
        dispatch_group_leave(group);

    }];
    
    dispatch_group_enter(group);
    
    [NetDataManger instanceResultDeviceId:OUTDEV andStartTime:stime andEndTime:etime Block:^(id dataValue) {
        
        NSLog(@"室外请求结束");
        // 返回的是realDataModel 数组
        _outFactorArr = [dataValue mutableCopy];
        
        dispatch_group_leave(group);
        
    }];

    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [LCLoadingHUD hideInView:self.view];
        
        // 设置数据，绘制折线图 初始显示PM2.5 数据
        // 获取全部的PM2.5 值，及对应时间
        NSMutableArray *infacValueArr = [NSMutableArray new];
        NSMutableArray *infacDateArr = [NSMutableArray new];
        
        NSMutableArray *outfacValueArr = [NSMutableArray new];
        NSMutableArray *outfacDateArr = [NSMutableArray new];
        
        [_inFactorArr enumerateObjectsUsingBlock:^(RealDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [infacValueArr addObject:[obj valueForKey:facto]];
            [infacDateArr addObject:obj.dateTime];
        }];
        
        [_outFactorArr enumerateObjectsUsingBlock:^(RealDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [outfacValueArr addObject:[obj valueForKey:facto]];
            [outfacDateArr addObject:obj.dateTime];
        }];
        
        if (_dayArr.count == 0) {
            _dayArr = [self backDayFromTimeArr:infacDateArr];
        }
        
        [_hisLine configDataWithTitle:_selectFactor InValue:infacValueArr
                              andInTime:infacDateArr
                            andOutValue:outfacValueArr
                             andOutTime:outfacDateArr andTopValue:_topValue];
        
    });

}






- (void)showSevenHistory:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    sender.layer.borderColor = RGBCOLOR(5, 175, 235).CGColor;
    [sender setTitleColor:RGBCOLOR(5, 175, 235) forState:UIControlStateNormal];
    _sigDay.layer.borderColor = white_color.CGColor;
    [_sigDay setTitleColor:white_color forState:UIControlStateNormal];
    sender.selected = YES;
    [_hisLine removeData];

    [self acquireHistoryDataWithStime:_startTime andeTime:_endTime factor:_selectFactor];
   
}

- (NSArray *)backDayFromTimeArr:(NSArray<NSString *> *)arr
{
    NSMutableSet *mset = [[NSMutableSet alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *day = [obj substringWithRange:NSMakeRange(0, 10)];
        [mset addObject:day];
    }];
    
    NSArray *tempArr = [mset allObjects];
    
    NSArray *sortArr =  [tempArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSLog(@"mset = %@",sortArr);
    
    return sortArr;
    
}


- (void)showSingleHistory:(UIButton *)sender
{

    _sevenBtn.selected = NO;
    [YBPopupMenu showRelyOnView:sender titles:_dayArr icons:nil menuWidth:130 andTag:101 delegate:self];

}


-(void)showMenu:(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:self.paramArr icons:nil menuWidth:130 andTag:100 delegate:self];

}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    
    if (ybPopupMenu.tag == 100) {
        NSLog(@"点击了 %@ 选项",self.paramArr[index]);
        
        switch (index) {
            case 0:
            {
             _selectFactor = @"pm2";
                _topValue = 500;
            }
                break;
            case 1:
            {
                _selectFactor = @"pm10";
                _topValue = 500;

            }
                break;
            case 2:
            {
                _selectFactor = @"co2";
                _topValue = 2000;


            }
                break;
            case 3:
            {
                _selectFactor = @"methanal";
                _topValue = 0.2;

            }
                break;
            default:
                break;
        }
        
        [_hisLine removeData];
        _sevenBtn.layer.borderColor = RGBCOLOR(5, 175, 235).CGColor;
        _sevenBtn.selected = YES;
        _sigDay.layer.borderColor = white_color.CGColor;
        [_sigDay setTitleColor:white_color forState:UIControlStateNormal];

        [_sevenBtn setTitleColor:RGBCOLOR(5, 175, 235) forState:UIControlStateNormal];

    [self acquireHistoryDataWithStime:_startTime andeTime:_endTime factor:_selectFactor];

    }
    
    if (ybPopupMenu.tag == 101) {
        NSString *timeDate = _dayArr[index];
        NSLog(@"点击了 %@ 选项",timeDate);
        _sigDay.layer.borderColor = RGBCOLOR(5, 175, 235).CGColor;
        [_sigDay setTitleColor:RGBCOLOR(5, 175, 235) forState:UIControlStateNormal];
        _sevenBtn.layer.borderColor = white_color.CGColor;
        [_sevenBtn setTitleColor:white_color forState:UIControlStateNormal];

        [_sigDay setTitle:timeDate forState:UIControlStateNormal];
        [_hisLine removeData];
        
        [self acquireHistoryDataWithStime:[timeDate stringByAppendingString:@" 00:00:00"] andeTime:[timeDate stringByAppendingString:@" 23:59:59"] factor:_selectFactor];
    }
    
    
    
}

- (void)currentDater
{
    NSCalendar *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [NSDateComponents new];
    NSDateComponents *comps1 = [NSDateComponents new];
    
    NSInteger unitFlags     = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    
    NSDate * sevdata = [NSDate dateWithTimeIntervalSinceNow:-7*24*3600];
    
    comps                   = [calendar components:unitFlags fromDate:now];
    
    NSInteger  year         = [comps year];
    NSInteger  month        = [comps month];
    NSInteger day           = [comps day];
    NSInteger hour          = [comps hour];
    NSInteger min           = [comps minute];
    NSInteger second        = [comps second];
    
    comps1                   = [calendar components:unitFlags fromDate:sevdata];
    
    NSInteger  year1         = [comps1 year];
    NSInteger  month1        = [comps1 month];
    NSInteger day1           = [comps1 day];
    NSInteger hour1          = [comps1 hour];
    NSInteger min1           = [comps1 minute];
    NSInteger second1       = [comps1 second];
    
    // 当前时间点
    _endTime       = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(unsigned long)year,(unsigned long)month,(unsigned long)day,(unsigned long)hour,min,(unsigned long)second];
    
    // 七天前时间点
    _startTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(unsigned long)year1,(unsigned long)month1,(unsigned long)day1,(unsigned long)hour1,(unsigned long)min1,(unsigned long)second1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
