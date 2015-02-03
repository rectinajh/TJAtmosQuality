//
//  TenderViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "TenderViewController.h"
#import "ConfigManager.h"
#import "ListTitleView.h"
#import "SiteObject.h"
#import "AQExponentView.h"
#import "AFAppDotNetAPIClient.h"

@interface TenderViewController ()<ListTitleDelegate> {
    ListTitleView *titleView;
    AQExponentView *exponentView;
    NSDictionary *dataDic;
}

@end

@implementation TenderViewController

static NSString *lastSiteId = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleView = [[ListTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleView.delegate = self;
    if (self.selecedIndex >= 0 && self.selecedIndex <= 6) {
        [titleView setSelectedIndex:self.selecedIndex];
    }
    [self.view addSubview:titleView];
    
    exponentView = [[AQExponentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.view.frame.size.height - 54 - 20 - 44 - 44)];
    [self.view addSubview:exponentView];
    
    if (self.siteId != nil) {
        [self loadData:self.siteId];
        SiteObject *siteObj = [[[Configure sharedInstance] getAllSites] objectForKey:self.siteId];
        self.navigationItem.title = [NSString stringWithFormat:@"%@趋势数据", siteObj.stationName];
        lastSiteId = self.siteId;
    }
}

- (void)getTenderData:(NSDictionary *)tenderDic {
//    NSLog(@"趋势图数据 ==== %@", tenderDic);
    dataDic = tenderDic;
    [self changePollutionType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.siteId == nil) {
        if ([lastSiteId isEqualToString:[Configure sharedInstance].siteId]) {
            return;
        }
        [self loadData:[Configure sharedInstance].siteId];
        SiteObject *siteObj = [[[Configure sharedInstance] getAllSites] objectForKey:[Configure sharedInstance].siteId];
        self.navigationItem.title = [NSString stringWithFormat:@"%@趋势数据", siteObj.stationName];
        lastSiteId = [Configure sharedInstance].siteId;
    }
}

- (void)loadData:(NSString *)siteId {
    NSString *url = [NSString stringWithFormat:@"tjhb/buildJsonAction!findAqi24HByClientIds?clientIds=%@", siteId];
    [[AFAppDotNetAPIClient sharedClient] requestDataInView:self.navigationController.view withURL:url forTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePollutionType {
    if (titleView.selectedIndex == 6) {
        exponentView.shouldFloat = YES;
    }else {
        exponentView.shouldFloat = NO;
    }
    NSArray *keys = @[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO", @"clientid", @"lasttime"];
    NSArray *dataArray = [dataDic objectForKey:keys[titleView.selectedIndex]];
    NSString *maxValue = [[[[Configure sharedInstance] getExponentDicWithYMax:[dataArray valueForKeyPath:@"@max.floatValue"] withType:keys[titleView.selectedIndex]] objectForKey:keys[titleView.selectedIndex]] lastObject];
    if (titleView.selectedIndex == 0) {
        [exponentView setPillars:dataArray withYMaxValue:[maxValue integerValue]];
    }else {
        [exponentView setPoints:dataArray withYMaxValue:[maxValue integerValue]];
        
    }
    NSDictionary *dic = [[Configure sharedInstance] getExponentDicWithYMax:[dataArray valueForKeyPath:@"@max.floatValue"] withType:keys[titleView.selectedIndex]];
    [exponentView setVercitalLine:[dic objectForKey:keys[titleView.selectedIndex]]];
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
