//
//  ViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "ViewController.h"
#import "ConfigManager.h"
#import "SiteDetail.h"
#import "AFAppDotNetAPIClient.h"
#import "SettingViewController.h"
#import "AddSitesViewController.h"
#import <SMPageControl/SMPageControl.h>

//siteview tag 500-600
#define SITEVIEWTAG 500

@interface ViewController ()

@property (nonatomic, strong) SMPageControl *pageControl;

@end

@implementation ViewController

static NSInteger siteViewsCount = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"REFRESHNOTIFATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"REFRESH_ITEMS_NOTIFATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSiteView:) name:@"SHOWSITENOTIFATION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RELOADAPPLICATIONDATA" object:nil];
    
    siteViewsCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"] count];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(gotoAddSitesViewController)];
    self.navigationItem.leftBarButtonItem = addItem;
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seting_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(gotoSettingViewController)];
    self.navigationItem.rightBarButtonItem = settingItem;
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame))];
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * siteViewsCount, scroll.frame.size.height);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.alwaysBounceVertical = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    scroll.tag = 1000;
    [self.view addSubview:scroll];
    
    SMPageControl *pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    pageControl.numberOfPages = siteViewsCount;
    pageControl.hidesForSinglePage = YES;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    [self sizePageControlIndicatorsToFit];
    
    for (int i = 0; i < siteViewsCount; i++) {
        SiteDetail *siteView = [[SiteDetail alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - (iOS7 ? 20 : 0) - 44 - 45)];
        siteView.siteId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"] objectAtIndex:i];
        [scroll addSubview:siteView];
        siteView.tag = SITEVIEWTAG + i;
        if (i == 0) {
            [Configure sharedInstance].siteId = siteView.siteId;
        }
    }
    
    NSString *url = @"tjhb/buildJsonAction!findAllStations";
    [[AFAppDotNetAPIClient sharedClient] requestDataInView:self.navigationController.view withURL:url forTarget:nil];
    [self loadData];
}


- (void)refreshView {
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:1000];
    for (int i = SITEVIEWTAG; i < SITEVIEWTAG + [[[[Configure sharedInstance] getAllSites] allValues] count]; i++) {
        [[scroll viewWithTag:i] removeFromSuperview];
    }
    
    siteViewsCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"] count];
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * siteViewsCount, scroll.frame.size.height);
    [scroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)) animated:NO];    
    
    self.pageControl.numberOfPages = siteViewsCount;
    self.pageControl.currentPage = 0;
    [self sizePageControlIndicatorsToFit];
    
    for (int i = 0; i < siteViewsCount; i++) {
        SiteDetail *siteView = [[SiteDetail alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame))];
        siteView.siteId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"] objectAtIndex:i];
        [scroll addSubview:siteView];
        siteView.tag = SITEVIEWTAG + i;
        if (i == 0) {
            [Configure sharedInstance].siteId = siteView.siteId;
        }
        [siteView applySiteData];
    }
}

- (void)showSiteView:(NSNotification *)notification {
    NSInteger index = [[notification object] integerValue] - 100;
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:1000];
    [scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)) animated:NO];

    self.pageControl.currentPage = index;
    SiteDetail *detail = (SiteDetail *)[[self.view viewWithTag:1000] viewWithTag:SITEVIEWTAG + self.pageControl.currentPage];
    [Configure sharedInstance].siteId = detail.siteId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadData {
    NSString *url = @"tjhb/buildJsonAction!findAll";
    [[AFAppDotNetAPIClient sharedClient] requestDataInView:self.navigationController.view withURL:url forTarget:self];
}

- (void)getAllSitesFinished {
//    NSLog(@"详细页面 json ==== %@", [[Configure sharedInstance] getAllSites]);
    for (int i = 0; i < siteViewsCount; i++) {
        SiteDetail *detail = (SiteDetail *)[[self.view viewWithTag:1000] viewWithTag:SITEVIEWTAG + i];
        [detail applySiteData];
    }
}

- (void)gotoAddSitesViewController {
    AddSitesViewController *add = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSitesViewController"];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)gotoSettingViewController {
    SettingViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    SiteDetail *detail = (SiteDetail *)[[self.view viewWithTag:1000] viewWithTag:SITEVIEWTAG + self.pageControl.currentPage];
    [Configure sharedInstance].siteId = detail.siteId;
}



#define PAGE_CONTROL_DEFAULT_PAGE_DIAMETER  8.0
#define PAGE_CONTROL_DEFAULT_PAGE_MARGIN    10.0
#define PAGE_CONTROL_MINIMUM_PAGE_DIAMETER  3.0
#define PAGE_CONTROL_MINIMUM_PAGE_MARGIN    5.0

- (void)sizePageControlIndicatorsToFit {
	// reset defaults
	[self.pageControl setIndicatorDiameter:PAGE_CONTROL_DEFAULT_PAGE_DIAMETER];
	[self.pageControl setIndicatorMargin:PAGE_CONTROL_DEFAULT_PAGE_MARGIN];
    
	NSInteger indicatorMargin = self.pageControl.indicatorMargin;
	NSInteger indicatorDiameter = self.pageControl.indicatorDiameter;
    
	CGFloat minIndicatorDiameter = PAGE_CONTROL_MINIMUM_PAGE_DIAMETER;
	CGFloat minIndicatorMargin = PAGE_CONTROL_MINIMUM_PAGE_MARGIN;
    
	NSInteger pages = self.pageControl.numberOfPages;
	CGFloat actualWidth = [self.pageControl sizeForNumberOfPages:pages].width;
    
	BOOL toggle = YES;
	while (actualWidth > CGRectGetWidth(self.pageControl.bounds) && (indicatorMargin > minIndicatorMargin || indicatorDiameter > minIndicatorDiameter)) {
		if (toggle) {
			if (indicatorMargin > minIndicatorMargin) {
				self.pageControl.indicatorMargin = --indicatorMargin;
			}
		} else {
			if (indicatorDiameter > minIndicatorDiameter) {
				self.pageControl.indicatorDiameter = --indicatorDiameter;
			}
		}
		toggle = !toggle;
		actualWidth = [self.pageControl sizeForNumberOfPages:pages].width;
	}
    
	if (actualWidth > CGRectGetWidth(self.pageControl.bounds)) {
		NSLog(@"Too many pages! Already at minimum margin (%d) and diameter (%d).", indicatorMargin, indicatorDiameter);
	}
}

@end
