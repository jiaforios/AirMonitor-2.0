//
//  PieView.m
//  AirMonitor
//
//  Created by zengjia on 16/12/11.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "PieView.h"
#import "AirMonitor-Bridging-Header.h"

@interface PieView ()
@property(nonatomic,strong)PieChartView *pieChartView;
@property(nonatomic,strong)PieChartData *data;

@end

@implementation PieView

-(instancetype)intancesFrom:(CGRect)frame
{
    PieView *pie = [[PieView alloc] initWithFrame:frame];
    return pie;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.pieChartView = [[PieChartView alloc] init];
        self.pieChartView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.pieChartView];
        
        [self.pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.offset(0);
        }];
        
        [self configPiewView];
        [self configDataWith:0];
        
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            [self configDataWith:arc4random_uniform(50)];
        }];
    }
    
    return self;
}

- (void)configPiewView
{
    
    [self.pieChartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];//饼状图距离边缘的间隙
//    self.pieChartView.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
//    self.pieChartView.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
    self.pieChartView.drawSliceTextEnabled = YES;//是否显示区块文本
    self.pieChartView.rotationEnabled = NO; // 禁止转动
    
    // 设置饼状图中间的空心样式
    
    self.pieChartView.drawHoleEnabled = YES;//饼状图是否是空心
    self.pieChartView.holeRadiusPercent = 0.9;//空心半径占比
    self.pieChartView.holeColor = [UIColor clearColor];//空心颜色
    self.pieChartView.transparentCircleRadiusPercent = 0.92;//半透明空心半径占比
    self.pieChartView.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];//半透明空心的颜色
    
    // 设置饼状图中心的文本
    
    if (self.pieChartView.isDrawHoleEnabled == YES) {
        self.pieChartView.drawCenterTextEnabled = YES;//是否显示中间文字
        //普通文本
        //        self.pieChartView.centerText = @"饼状图";//中间文字
        //富文本
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"CO2"];
        [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:8],
                                    NSForegroundColorAttributeName: [UIColor orangeColor]}
                            range:NSMakeRange(0, centerText.length)];
        self.pieChartView.centerAttributedText = centerText;
    }

    // 设置图例样式
    self.pieChartView.legend.enabled = NO;
    self.pieChartView.descriptionText = @"CO2";
    

}

- (void)configDataWith:(int)a
{
    NSMutableArray *yvalues = [[NSMutableArray alloc] init];
    
    [yvalues addObject:[[PieChartDataEntry alloc] initWithValue:a label:@""]];
    
    [yvalues addObject:[[PieChartDataEntry alloc] initWithValue:100-a label:@""]];
    
    NSString *valuer =[NSString stringWithFormat:@"%d%%",a];
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:valuer];
    [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:8],
                                NSForegroundColorAttributeName: [UIColor orangeColor]}
                        range:NSMakeRange(0, centerText.length)];
    self.pieChartView.centerAttributedText = centerText;
    
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:yvalues label:@"Election Results"];
//    dataSet.sliceSpace = 2.0;  // 相邻区块间距
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    //    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObject:[UIColor blueColor]];
    [colors addObject:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
    
    dataSet.colors = colors;  // 设置区块颜色
    dataSet.drawValuesEnabled = NO; // 显示占比数据
    dataSet.selectionShift = 0; // 选中区块时放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice; // 名称位置
    dataSet.yValuePosition = PieChartValuePositionInsideSlice;// 数据位置
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    // 设置显示数据样式
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [data setValueTextColor:[UIColor blueColor]];
    self.pieChartView.data = data;
    [self.pieChartView highlightValues:nil];

}

-(void (^)(int))changeWithDateValue
{
    return ^(int value){
        [self configDataWith:value];
    };
}


@end






