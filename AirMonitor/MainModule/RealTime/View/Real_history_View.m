//
//  Real_history_View.m
//  AirMonitor
//
//  Created by foscom on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "Real_history_View.h"
#import "NSString+DataValue.h"
#import <WebKit/WebKit.h>
#import "NetHelper.h"
#import "RealDataModel.h"
#import "MJExtension.h"
#import "UIColor+DataValue.h"

@interface Real_history_View ()

@property(nonatomic,strong)UILabel *dataLabel; // 显示实时数据
@property(nonatomic,strong)UILabel *rankLabel; //从显示优良
@property(nonatomic,strong)UILabel *dataTime; // 显示PM2.5
@property(nonatomic,strong)WKWebView *wkview;
@property(nonatomic,strong)NSTimer *dataTimer; // 获取数据的timer
@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)UILabel *place;

@end

@implementation Real_history_View

-(instancetype)initWithFrame:(CGRect)frame withId:(NSString *)deviceId
{
    if (self = [super initWithFrame:frame]) {
        _deviceId = deviceId;
        [self addSubview:self.dataLabel];
        [self addSubview:self.rankLabel];
        [self addSubview:self.wkview];
        [self addSubview:self.dataTime];
        [self addSubview:self.place];
        [self acquireDataWithDeviceId:deviceId];
        [self.place mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(20);
        }];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(50);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(150);
            
        }];
        
        [self.dataTime mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(self);
            make.top.equalTo(self.dataLabel.mas_bottom).with.offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        
        }];
        
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-20);
            make.top.equalTo(self).with.offset(50);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
            
        }];
        
        [self.wkview mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self).with.offset(-49);
            make.left.equalTo(self).with.offset(0);
            make.width.mas_equalTo(MZ_WIDTH/2.0);
            make.height.mas_equalTo(150+49);

        }];
        
    }
    
    return self;
}

-(void)acquireDataWithDeviceId:(NSString *)deviceId
{
   _dataTimer =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAcquireData) userInfo:nil repeats:YES];
    
}

- (void)timeAcquireData
{
    [[NetHelper shareNetManger] getAirInformationWithUrl:kBaseUrl andDeviceId:_deviceId andBackBlock:^(id value) {
        RealDataModel *model = [RealDataModel mj_objectWithKeyValues:value];
        [self changeDataValue:model];
    }];
}

- (UILabel *)place
{
    if (_place == nil) {
        _place = [[UILabel alloc] init];
        _place.textAlignment = NSTextAlignmentCenter;
        _place.textColor = [UIColor whiteColor];
        _place.font = font_17;
        if (![_deviceId isEqualToString:OUTDEV]) {
            _place.text = @"办公区";
        }else
        {
            
            NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
            if (location) {
                _place.text = [@"西安市 " stringByAppendingString:location];
            }
        }
    }
    
    return _place;
}

-(WKWebView *)wkview
{
    if (_wkview == nil) {
        _wkview = [[WKWebView alloc] init];
        [_wkview setOpaque:NO];
        NSString *basePath = [[NSBundle mainBundle] bundlePath];
        NSString *file = [[NSBundle mainBundle] pathForResource:@"dataTable" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        NSURL *urlpath = [NSURL fileURLWithPath:basePath isDirectory:YES];
        [self.wkview loadHTMLString:html baseURL:urlpath];
        self.wkview.userInteractionEnabled = NO;

    }
    return _wkview;
}

- (UILabel *)dataLabel
{
    if (_dataLabel == nil) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = font_80;
        _dataLabel.textColor = [UIColor whiteColor];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dataLabel;
    
}

- (UILabel *)rankLabel
{
    if (_rankLabel == nil) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.font = font_15;
        _rankLabel.textColor = [UIColor whiteColor];
        _rankLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _rankLabel;
}

- (UILabel *)dataTime
{
    if (_dataTime == nil) {
        _dataTime = [[UILabel alloc] init];
//        _dataTime.font = font_17;
        _dataTime.textColor = [UIColor whiteColor];
        
//        NSDate *date = [NSDate date];
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateStr = [format stringFromDate:date];
        
        _dataTime.text = @"PM2.5";
        _dataTime.font = [UIFont systemFontOfSize:30];
        _dataTime.textAlignment = NSTextAlignmentCenter;
    }
    return  _dataTime;
}


-(void)changeDataValue:(RealDataModel *)valueModel
{
    NSString * value =  valueModel.pm2;
    self.dataLabel.text = value;
    self.rankLabel.text = [NSString stringFromValue:[value integerValue]];
    self.backgroundColor = [UIColor colorWith_PM25_DataValue:[value integerValue]];
    [self.wkview evaluateJavaScript:[self jsString:valueModel] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        error?NSLog(@"error = %@",[error description]):nil;
    }];

}

- (NSString *)jsString:(RealDataModel *)model
{
    NSString *jsStr =[NSString stringWithFormat: @"var dataArr=new Array();\
                       dataArr[0]=%@;\
                       dataArr[1]=%@;\
                       dataArr[2]=%@;\
                       dataArr[3]=%@;\
                       dataArr[4]=%@;\
                       dataArr[5]=%@;\
                       changeValue(dataArr);",model.temperature,model.humidity,model.pm10,model.co2,model.methanal,model.tvoc];
    return jsStr;
    
}

- (void)dealloc
{
    [_dataTimer invalidate];
    _dataTimer = nil;
}


@end



