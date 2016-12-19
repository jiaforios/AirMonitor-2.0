//
//  CalendView.m
//  AirMonitor
//
//  Created by foscom on 16/12/16.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "CalendView.h"

@implementation CalendView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"CalendView" owner:nil options:nil][0];
        self.frame = frame;
    }
    
    return self;
}


- (void)dealWithCalData:(id)value
{
    
    NSDictionary *dic = (NSDictionary *)value;
    NSDictionary *dict = dic[@"data"];
    [self dealDataYear:dict[@"lunarYear"] andAni:dict[@"animalsYear"] andYang:dict[@"date"] andYin:dict[@"lunar"] andFit:dict[@"suit"] andWeek:dict[@"weekday"] andNoFit:dict[@"avoid"]];

}

-(void)dealDataYear:(NSString *)year
             andAni:(NSString *)ani
            andYang:(NSString *)yang
             andYin:(NSString *)yin
             andFit:(NSString *)fit
            andWeek:(NSString *)week
           andNoFit:(NSString *)nofit
{
    _yearLabel.text = year;
    _YangLabel.text = [[yang stringByAppendingString:@" "] stringByAppendingString:week];
    _YinLabel.text = yin;
    _animalLabel.text = [ani stringByAppendingString:@"年"];
    _fitLabel.text  = fit;
    _fitLabel.adjustsFontSizeToFitWidth = YES;
    _nofitLabel.adjustsFontSizeToFitWidth = YES;
    _nofitLabel.text = nofit;
}


@end
