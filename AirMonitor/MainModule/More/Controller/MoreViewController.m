//
//  MoreViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutViewController.h"
#import "NetHelper.h"
#import "HUDManger.h"
#import "XHToast.h"
#import "LoginViewController.h"

static NSString *cellId = @"Morecell";
@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataSource addObject:MZLocalizedString(@"more_net")];
    [self.dataSource addObject:MZLocalizedString(@"more_ChectNewVersion")];
    [self.dataSource addObject:MZLocalizedString(@"more_Score")];
    [self.dataSource addObject:MZLocalizedString(@"more_about")];


    [self.view addSubview:self.tabView];
    
}

- (UITableView *)tabView
{
    if (_tabView == nil) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, MZ_WIDTH, MZ_HEIGHT) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = [UIColor clearColor];
        UILabel *footline = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, MZ_WIDTH-20, 1)];
        footline.backgroundColor = RGBCOLOR(61, 60, 68);
    
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, 200)];
        
        UIButton *logOut = [UIButton buttonWithType:UIButtonTypeCustom];
        logOut.frame = CGRectMake(0, 0, MZ_WIDTH-40, 40);
        logOut.center = CGPointMake(footView.center.x-CGRectGetMinX(footView.frame), footView.center.y-CGRectGetMinY(footView.frame));
        [logOut setTitle:MZLocalizedString(@"logOut") forState:UIControlStateNormal];
        logOut.layer.cornerRadius = 5;
        logOut.backgroundColor = [UIColor redColor];
        [logOut addTarget:self action:@selector(LogOutAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:footline];
        [footView addSubview:logOut];
        
        
        _tabView.tableFooterView = footView;
        [_tabView setSeparatorColor:RGBCOLOR(61, 60, 68)];
//        [_tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        
    }
    
    return _tabView;
}


- (void)LogOutAction
{
    LoginViewController *login = [[LoginViewController alloc] init];
    
    [self presentViewController:login animated:YES completion:nil];

}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.font = font_15;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = white_color;
    if (indexPath.row == 1) {
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        NSString *str = @"当前版本号：v";
        label.text  = [str stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ;
        
        label.textColor = white_color;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = label;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kDevNetUrl]];
        }
            break;

        case 1:
        {
            [HUDManger shareHudManger].showAnimate(YES,20);
            
            [[NetHelper shareNetManger] requestAPPVersionWithUrlstring:APPVERSIONURL withBlock:^(id dat) {
                
                NSDictionary *data = (NSDictionary *)dat;
                
                NSArray *resultArr = data[@"results"];
                
                if (resultArr.count!=0) {
                    
                    NSDictionary *dic = resultArr[0];
                    NSString *version = dic[@"version"];
                    NSString *appUrl = dic[@"trackViewUrl"];
                    //            NSString *updateContent = dic[@"releaseNotes"];
                    
                    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    
                    
                    if([localVersion compare:version] < 0)
                    {
                        [HUDManger shareHudManger].showAnimate(NO,0);

                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            UIAlertController *all = [UIAlertController alertControllerWithTitle:@"发现新版本" message:[NSString stringWithFormat:@"%@:%@",@"新版本",version] preferredStyle:UIAlertControllerStyleAlert];
                            
                            [all addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"appversion"];
                                
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                
                            }]];
                            
                            
                            [all addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
                                
                                
                            }]];
                            
                            [self presentViewController:all animated:YES completion:nil];
                            
                            
                        });
                        
                    }else
                    {
                        [HUDManger shareHudManger].showAnimate(NO,2);

                        [XHToast showFailContent:@"当前已是最新版本!" hiddenTime:2];
                    }
                }
                
            }];

        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ScoreUrlStr]];

        }
            break;
        case 3:
        {
            AboutViewController *about = [AboutViewController new];
            [self.navigationController pushViewController:about animated:YES];

        }
            break;

        default:
            break;
    }
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
