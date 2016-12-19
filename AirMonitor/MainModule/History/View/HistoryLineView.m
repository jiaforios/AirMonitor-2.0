//
//  HistoryLineView.m
//  AirMonitor
//
//  Created by zengjia on 16/12/12.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "HistoryLineView.h"
#import "AirMonitor-Bridging-Header.h"
#import "xValueFormat.h"
@interface HistoryLineView ()<ChartViewDelegate>

@property(nonatomic,strong)LineChartView *lineView;
@property(nonatomic,strong)LineChartData *lineData;


@end

@implementation HistoryLineView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).with.offset(0);
        }];
    }

    return self;
}

- (LineChartView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[LineChartView alloc] init];
        _lineView.noDataText = @"";
        _lineView.noDataFont = [UIFont systemFontOfSize:20];
        _lineView.delegate  = self;

        
    }
    return _lineView;
}

-(void)configDataWithTitle:(NSString *)title
                   InValue:(NSArray *)inValue
                   andInTime:(NSArray *)intime
                 andOutValue:(NSArray *)outValue
                  andOutTime:(NSArray *)outTime
                 andTopValue:(NSInteger)topValue
{
    NSLog(@"timeCount = %lu",(unsigned long)intime.count);
    [self configViewWithXData:intime andTopValue:topValue];
//    [self configData];
    NSMutableArray *yValsin = [[NSMutableArray alloc] init];

    for (int i = 0; i<inValue.count; i++) {
        
        [yValsin addObject:[[ChartDataEntry alloc] initWithX:i y:[inValue[i] doubleValue]]];
    }
    
    NSMutableArray *yValsOut = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<outValue.count; i++) {
        
        [yValsOut addObject:[[ChartDataEntry alloc] initWithX:i y:[outValue[i] doubleValue]]];
    }

    LineChartDataSet *set1 = nil;
    set1 = [[LineChartDataSet alloc] initWithValues:yValsin label:[MZLocalizedString(title) stringByAppendingString:@" 室内曲线"]];
    set1.axisDependency = AxisDependencyLeft;
    //    [set1 setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    [set1 setCircleColor:[UIColor whiteColor]];  // 设置圈颜色
    set1.lineWidth = 2.0;
    set1.circleRadius = 2;
//        set1.fillAlpha = 0;
//        set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f]; // 十字交叉线颜色
    set1.drawCircleHoleEnabled = NO;
    set1.highlightEnabled = YES; // 点击十字交叉线显示
    
    if (inValue.count<50) {
        set1.drawValuesEnabled = YES; // 单日显示值
    }else
    {
        set1.drawValuesEnabled = NO; // 不显示值
    }
    [set1 setColor:RGBCOLOR(34, 139, 34)]; // 设置折线颜色

    LineChartDataSet *setOut = nil;
    setOut = [[LineChartDataSet alloc] initWithValues:yValsOut label:[MZLocalizedString(title) stringByAppendingString:@"室外曲线"]];
    setOut.axisDependency = AxisDependencyLeft;
    //    [set1 setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    [setOut setCircleColor:[UIColor whiteColor]];  // 设置圈颜色
    [setOut setColor:[UIColor redColor]]; // 设置折线颜色
    setOut.lineWidth = 2.0;
    setOut.circleRadius = 2;
    setOut.fillAlpha = 65/255.0;
    setOut.circleHoleRadius = 2.0;
    //    set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    setOut.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    setOut.drawCircleHoleEnabled = NO;
    setOut.highlightEnabled = YES; // 点击十字交叉线显示
    if (inValue.count<50) {
        setOut.drawValuesEnabled = YES; // 单日显示值
    }else
    {
        setOut.drawValuesEnabled = NO; // 不显示值
    }

    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:setOut];
    
    
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueTextColor:[UIColor whiteColor]];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _lineView.data = data;
    
    
}

- (void)removeData
{
       _lineView.data = nil;
    [_lineView setNeedsDisplay];
    
}

- (void)configViewWithXData:(NSArray *)xvalue andTopValue:(NSInteger)topValue
{
    // 设置交互样式
    _lineView.scaleYEnabled = YES;//Y轴缩放
    _lineView.doubleTapToZoomEnabled = YES;//双击缩放
    _lineView.dragEnabled = YES;//启用拖拽图标
    _lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    _lineView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
//    [_lineView setScaleMinima:2 scaleY:1]; // 设置初始放大比例
    // 设置X轴
    ChartXAxis *xAxis = _lineView.xAxis;
    xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//绘制网格线
    xAxis.spaceMin = 4;
    xAxis.labelTextColor = [UIColor whiteColor];//label文字颜色
    xAxis.axisMinimum = 0;
    xAxis.valueFormatter = [[xValueFormat alloc] initForChart:_lineView WithTimeArr:xvalue];
    
    _lineView.rightAxis.enabled = NO;//不绘制右边轴

    ChartYAxis *leftAxis = _lineView.leftAxis;
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    leftAxis.axisMaximum = topValue;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = YES;

    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor whiteColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体

    // 网格样式
//    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
//    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
//    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿

    // 设置限制线
//    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];
//    limitLine.lineWidth = 2;
//    limitLine.lineColor = [UIColor greenColor];
//    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
//    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
//    limitLine.valueTextColor = [UIColor blueColor];//label文字颜色
//    limitLine.valueFont = [UIFont systemFontOfSize:12];//label字体
//    [leftAxis addLimitLine:limitLine];//添加到Y轴上
//    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在折线图的后面
//
    
    
//    _lineView.marker
    
    
    // 设置图例及描述
    [_lineView setDescriptionText:@""];//折线图描述
    [_lineView setDescriptionTextColor:[UIColor whiteColor]];
    _lineView.legend.form = ChartLegendFormLine;//图例的样式
    _lineView.legend.formSize = 20;//图例中线条的长度
    _lineView.legend.font = [UIFont systemFontOfSize:12];
    _lineView.legend.textColor = [UIColor whiteColor];//图例文字颜色
    
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    
    [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    
    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


@end









