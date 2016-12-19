//
//  WeatherView.m
//  AirMonitor
//
//  Created by foscom on 16/12/13.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "WeatherView.h"
#import "NetHelper.h"
#import "WeatherModel.h"
#import "MJExtension.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherView ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManger;
@property(nonatomic,copy)NSString *locations;
@property(nonatomic,copy)void(^rBlock)();

@end

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame andresultBlock:(void(^)())block
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil][0];
        self.frame = frame;
        self.rBlock = block;
        self.backgroundColor = [UIColor clearColor];
        [self acquireLocation];
    }
    return self;
}

- (void)acquireLocation
{
    _locationManger = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManger.delegate = self;
    // 设置定位精确度到米
    _locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManger.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManger requestWhenInUseAuthorization];//这句话ios8以上版本使用。
    [_locationManger startUpdatingLocation];

}


-(void)setLocations:(NSString *)locations
{
    _locations = locations;
    NSMutableString *str = [_locations mutableCopy];
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
   
    NSLog(@"str = %@",str);
    
    [[NetHelper shareNetManger] get_now_weatherInfoWithCity:str resultBlock:^(id data) {
        WeatherModel *wModel = [WeatherModel mj_objectWithKeyValues:data];
        NSDictionary *dic = [wModel.HeWeather5 firstObject];
        //        _status.text
        NSDictionary *dic2 = dic[@"now"][@"cond"];
        _loacation.text = locations;
        _status.text = dic2[@"txt"];
        _temp.text = [dic[@"now"][@"tmp"] stringByAppendingString:@" ℃"];
        _direct.text = dic[@"now"][@"wind"][@"dir"];
        _rank.text = [dic[@"now"][@"wind"][@"sc"] stringByAppendingString:@" 级"];
        _pic.image = [UIImage imageNamed:dic2[@"code"]];
        _rBlock?_rBlock():nil;
    }];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [manager stopUpdatingLocation];

    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
 
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
           for (CLPlacemark *place in placemarks) {
               if (_locations == nil) {
                   self.locations = place.locality;
               }
//            NSLog(@"name,%@",place.name);                       // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//            NSLog(@"locality,%@",place.locality);               // 市
//            NSLog(@"subLocality,%@",place.subLocality);         // 区
//            NSLog(@"country,%@",place.country);                 // 国家
        }
                       
    }];

}

@end






