//
//  AddSitesViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "AddSitesViewController.h"
#import "ConfigManager.h"
#import "SiteItemVIew.h"
#import "SiteObject.h"
#import "SiteItemAddView.h"

#import "SiteListViewController.h"

@interface AddSitesViewController () <SiteItemVIewDelegate, SiteItemAddViewDelegate> {
    NSMutableArray *sitesArray;
}

@property (strong, nonatomic) UIScrollView *scrollView_;

@end

@implementation AddSitesViewController

static BOOL isShowDel = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:209.0/255.0 blue:217.0/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDeleteAction) name:@"DELETENOTIFATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"REFRESHNOTIFATION" object:nil];
    
    sitesArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 20 - 44 - 44)];
//    scroll.scrollsToTop = NO;
    [self.view addSubview:scroll];
    self.scrollView_ = scroll;
    [self refreshView];
}

- (void)refreshView {
    for (UIView *sub in self.scrollView_.subviews) {
        [sub removeFromSuperview];
    }
    [sitesArray removeAllObjects];
    
    NSArray *defaultSites = [[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"];
    for (int i = 0; i < [defaultSites count]; i++) {
        SiteItemVIew *item = [[SiteItemVIew alloc] initWithFrame:[self getFrameByTag:100 + i]];
        
        SiteObject *siteObj = [[[Configure sharedInstance] getAllSites] objectForKey:[defaultSites objectAtIndex:i]];
        [item setSiteName:siteObj.stationName];
        [item setSiteRegion:siteObj.quyudex];
        item.siteId = siteObj.clientid;
        item.tag = 100 + i;
        [self.scrollView_ addSubview:item];
        [sitesArray addObject:item];
        item.delegate = self;
    }
    SiteItemAddView *add = [[SiteItemAddView alloc] initWithFrame:[self getFrameByTag:100 + [defaultSites count]]];
    add.tag = 100 + [defaultSites count];
    add.delegate = self;
    [self.scrollView_ addSubview:add];
    [sitesArray addObject:add];
    
    self.scrollView_.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 100 * ((([defaultSites count] + 1) % 3) == 0 ? (([defaultSites count] + 1) / 3) : (([defaultSites count] + 1) / 3) + 1));
//    self.scrollView_.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 1000);
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDeleteAction {
    for (int i = 1; i < [sitesArray count]; i++) {
        if ([[sitesArray objectAtIndex:i] isKindOfClass:[SiteItemVIew class]]) {
            SiteItemVIew *item = (SiteItemVIew *)[sitesArray objectAtIndex:i];
            [item showDeleteButton:YES];
        }
    }
    isShowDel = YES;
}

- (void)resetItemsView:(NSInteger)deleteTag {
    [sitesArray removeObjectAtIndex:deleteTag - 100];
    for (int i = deleteTag - 100; i < [sitesArray count]; i++) {
        //改变位置
        [UIView animateWithDuration:0.4 animations:^{
            UIView *item = sitesArray[i];
            item.tag -= 1;
            item.frame = [self getFrameByTag:item.tag];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (CGRect)getFrameByTag:(NSInteger)tag {
    NSInteger index = tag - 100;
    CGRect frame = CGRectMake(10 + 100 * (index % 3), 100 * (index / 3), 100, 100);
    return frame;
}

- (void)addItemAction {
    SiteListViewController *siteList = [self.storyboard instantiateViewControllerWithIdentifier:@"SiteListViewController"];
    [self.navigationController pushViewController:siteList animated:YES];
}

- (BOOL)hideAllDeleteBtn {
    if (isShowDel) {
        for (int i = 1; i < [sitesArray count]; i++) {
            if ([[sitesArray objectAtIndex:i] isKindOfClass:[SiteItemVIew class]]) {
                SiteItemVIew *item = (SiteItemVIew *)[sitesArray objectAtIndex:i];
                [item showDeleteButton:NO];
            }
        }
        isShowDel = NO;
        return YES;
    }
    return NO;
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
