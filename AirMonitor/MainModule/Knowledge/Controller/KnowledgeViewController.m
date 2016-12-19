//
//  KnowLedgeViewController.m
//  AirMonitor
//
//  Created by zengjia on 16/12/8.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "WebKitVC.h"
#import "QuestionViewController.h"
#import "HUDManger.h"
#import <WebKit/WebKit.h>
static NSString *cellId = @"knowledgecell";

@interface KnowledgeViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSString *allTitles;
@property(nonatomic,copy)NSString *allContents;

@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *section1 = @[MZLocalizedString(@"knowledge_pm2.5"),MZLocalizedString(@"knowledge_pm2.5deal"),MZLocalizedString(@"knowledge_heath"),MZLocalizedString(@"knowledge_standard")];

//    NSArray *section2 = @[MZLocalizedString(@"knowledge_standard")];
    
    [self.dataSource addObject:section1];
//    [self.dataSource addObject:section2];
    
    // 注册对应的植入名
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"AppTest"];
    [config.userContentController addScriptMessageHandler:self name:@"AppTestcontent"];

    
    WKWebView *wkweb = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wkweb.navigationDelegate = self;
    [wkweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.smart029.com/a/jishuzhichi/changjianwenti"]]];
    wkweb.hidden = YES;
    [self.view addSubview:wkweb];
    
    [self.view addSubview:self.tabView];

}

// 接收植入返回结果
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppTest"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSDictionary *dic = message.body;
        self.allTitles = dic[@"body"];
    }
    
    if ([message.name isEqualToString:@"AppTestcontent"]) {
        NSDictionary *dic = message.body;
        self.allContents = dic[@"body"];
    }
    if (self.allContents && self.allTitles) {
        
        
        NSArray *titleArr = [self.allTitles componentsSeparatedByString:@"==question=="];
        NSMutableArray *allArr = [titleArr mutableCopy];
        
        [titleArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.length == 0) {
                [allArr removeObject:obj];
            }
        }];
        
        [self.dataSource addObject:allArr];
        
        [self.tabView reloadData];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载");
    [HUDManger shareHudManger].showAnimate(YES,20);
    [HUDManger shareHudManger].labelTextStr(@"请稍等...");
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载结束");
    [HUDManger shareHudManger].showAnimate(NO,0);

    // 植入传递内容脚本
    [webView evaluateJavaScript:@"var arr = document.getElementsByClassName('titleForiOSUse');\
     var alldata = '';\
     for (var i = 0; i<arr.length; i++)\
     {\
         var x = arr[i];\
         alldata = alldata + x.innerHTML +'==question==';\
     };\
     window.webkit.messageHandlers.AppTest.postMessage({body: alldata});" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
         NSLog(@"js_oc error :%@",[error description]);
        
    }];
    
    
    [webView evaluateJavaScript:@"var arr = document.getElementsByClassName('contentForiOSUse');\
     var alldata = '';\
     for (var i = 0; i<arr.length; i++)\
     {\
     var x = arr[i];\
     alldata = alldata + x.innerHTML +'==question==';\
     };\
     window.webkit.messageHandlers.AppTestcontent.postMessage({body: alldata});" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
         NSLog(@"js_oc error :%@",[error description]);
         
     }];
    
}

- (void)octest
{
    NSLog(@"js 调用oc 方法");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败");
}



- (UITableView *)tabView
{
    if (_tabView == nil) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MZ_WIDTH, MZ_HEIGHT-49) style:UITableViewStyleGrouped];
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
        if (indexPath.row == 3) {
            wvc.urlPath = @"AQI";
        }
    }
    
    if (indexPath.section == 1) {
        
        QuestionViewController *ques = [[QuestionViewController alloc] init];
        NSArray *contentArr = [self.allContents componentsSeparatedByString:@"==question=="];
        NSMutableArray *allArr = [contentArr mutableCopy];
        
        [contentArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length == 0) {
                [allArr removeObject:obj];
            }
        }];

        ques.content = contentArr[indexPath.row];
        [self.navigationController pushViewController:ques animated:YES];
        return;
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
