//
//  SettingViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SettingViewController.h"
#import "ConfigManager.h"
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

static NSString *updateURL = nil;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 130, SCREEN_WIDTH, 40)];
    label.textColor = BLACK_COLOR;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = @"©天津市环境监测中心\n技术支持：有度致远（天津）";
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkUpdate {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = @"http://60.28.63.213:9000/tjhb/buildJsonAction!findVersion?type=apple";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[AFAppDotNetAPIClient sharedClient].operationQueue addOperation:[[AFAppDotNetAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        float serverVersion = [[dic objectForKey:@"versionCode"] floatValue];
        float localVersion = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"] floatValue];
        if (serverVersion > localVersion) {
            updateURL = [dic objectForKey:@"url"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"检查到新版本V%@", [dic objectForKey:@"versionCode"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你现在已经是最新版本!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"url == %@,  error === %@", url, [error localizedDescription]);
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败,请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlert show];
    }]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *titles = @[@"实时发布说明", @"新版本更新"];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            NSString *string = @"\t1、发布依据：根据《环境空气质量标准》（GB3095-2012），以及《环境空气质量指数（AQI）技术规定（试行）》的有关规定，发布天津市环境空气质量实时监测数据。\n\t2、发布内容：环境空气质量指数（AQI），颗粒物（PM2.5，粒径小于等于2.5μm），颗粒物（PM10，粒径小于等于10μm），二氧化硫（SO2），二氧化氮（NO2），臭氧（O3），一氧化碳（CO）。\n\t3、数据来源：天津市环境空气质量自动监测站点实时监测数据，发布频率为每小时更新一次。\n\t4、发布说明：当遇到监测站点仪器维护校零、校标，仪器故障、通信故障、电力故障等原因，数据会暂时出现“/”或者无数据情况。\n";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"实时发布说明" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 1: {
            [self checkUpdate];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
