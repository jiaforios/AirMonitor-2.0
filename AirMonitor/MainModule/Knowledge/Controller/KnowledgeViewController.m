//
//  KnowLedgeViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "WebKitVC.h"
static NSString *cellId = @"knowledgecell";

@interface KnowledgeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *section1 = @[MZLocalizedString(@"knowledge_pm2.5"),MZLocalizedString(@"knowledge_pm2.5deal"),MZLocalizedString(@"knowledge_heath")];
    
    NSArray *section2 = @[MZLocalizedString(@"knowledge_standard")];
    
    [self.dataSource addObject:section1];
    [self.dataSource addObject:section2];

    [self.view addSubview:self.tabView];


}
- (UITableView *)tabView
{
    if (_tabView == nil) {
        _tabView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = [UIColor clearColor];
        _tabView.tableFooterView = [[UIView alloc] init];
//        [_tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tabView setSeparatorColor:RGBCOLOR(61, 60, 68)];
        [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        
    }
    
    return _tabView;
}


- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [_dataSource[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = font_15;
    cell.textLabel.textColor = white_color;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WebKitVC *wvc = [[WebKitVC alloc] init];
    wvc.urlTitle = cell.textLabel.text;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            wvc.urlPath = @"pm2_5";
        }
        if (indexPath.row == 1) {
            wvc.urlPath = @"pm25deal";
        }
        if (indexPath.row == 2) {
            wvc.urlPath = @"health";
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            wvc.urlPath = @"AQI";
        }
    }
    [self.navigationController pushViewController:wvc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
