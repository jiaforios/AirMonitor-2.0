//
//  weekDayView.m
//  NVRFunction
//
//  Created by foscom on 16/9/28.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "weekDayView.h"

#define btn_base_tag  1000

@interface weekDayView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)weekDayBlock weekBlock;
@property(nonatomic,strong)UIWindow *weekWindow;
@property(nonatomic,strong)NSArray *daysSource;

@property(nonatomic,assign)STYLETYPE styles;
@property(nonatomic,strong)DeleteBlock d_block;
@property(nonatomic,strong)UITableView *tabview;


@end
@implementation weekDayView

+ (instancetype)shareDaysWith:(NSArray *)days ResultBlock:(weekDayBlock)dayBlock
{
    weekDayView * weekView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    weekView.weekBlock = dayBlock;
    weekView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    weekView.daysSource = [days mutableCopy];
    weekView.styles = DEFAULT;
    weekView.weekWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [weekView maketabView];
    [weekView.weekWindow addSubview:weekView];
    [weekView.weekWindow becomeKeyWindow];
    [weekView.weekWindow makeKeyAndVisible];
    return weekView;

}


- (void)reloadViewWithArr:(NSArray *)arr
{
    _daysSource = [arr mutableCopy];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tabview reloadData];
    });
}


- (void)dismissWeekView
{
    [self.weekWindow resignKeyWindow];
    [self removeFromSuperview];
}

- (void)maketabView
{
     _tabview = [[UITableView alloc] initWithFrame:CGRectMake(25, 0, [UIScreen mainScreen].bounds.size.width -50, 44*5)];
    
    _tabview.delegate = self;
    _tabview.dataSource = self;
    _tabview.center = self.center;
    _tabview.layer.cornerRadius = 5;
    _tabview.backgroundColor = white_color;
    _tabview.clipsToBounds = YES;
    _tabview.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tabview];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissWeekView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _daysSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _weekBlock(_daysSource[indexPath.row]);
//    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"weekday"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self dismissWeekView];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _daysSource[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:100/256. green:100/256. blue:100/256. alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = white_color;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}


@end




