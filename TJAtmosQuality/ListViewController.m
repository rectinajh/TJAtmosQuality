//
//  ListViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "ListViewController.h"
#import "ConfigManager.h"
#import "ListTitleView.h"
#import "SiteObject.h"

#import "TenderViewController.h"

@interface ListViewController () <ListTitleDelegate> {
    ListTitleView *titleView;
    NSMutableArray *dataArray;
}

@end

@implementation ListViewController

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
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    NSSortDescriptor *sortByObject = [NSSortDescriptor sortDescriptorWithKey:@[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"][titleView.selectedIndex] ascending:NO comparator:^(id obj1, id obj2) {
        
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    dataArray = [[NSMutableArray alloc] initWithArray:[[[[Configure sharedInstance] getAllSites] allValues] sortedArrayUsingDescriptors:@[sortByObject]]];
    
    titleView = [[ListTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row % 2 != 0) {
        cell.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:122.0/255.0];
        cell.contentView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:122.0/255.0];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }

    SiteObject *object = dataArray[indexPath.row];
    cell.textLabel.text = object.stationName;
    
    if (titleView.selectedIndex == 0) {
        //首要污染物
        NSArray *criticalArray = [object.criticalPollutants componentsSeparatedByString:@"_"];
        if ([[criticalArray firstObject] isEqualToString:@"数据不足"] || [[criticalArray firstObject] isEqualToString:@"--"]) {
            cell.detailTextLabel.text = @"首要污染物：/";
        }else {
            NSMutableAttributedString *criticalAttri = [[NSMutableAttributedString alloc] initWithString:@""];
            for (int i = 0; i < [criticalArray count]; i++) {
                if ([criticalArray[i] isEqualToString:@"8H"] || [criticalArray[i] isEqualToString:@"8h"] || [criticalArray[i] isEqualToString:@"24H"] || [criticalArray[i] isEqualToString:@"24h"]) {
                    continue;
                }
                NSMutableAttributedString *criticalPollutants = [[NSMutableAttributedString alloc] initWithString:criticalArray[i]];
                if ([criticalPollutants.string isEqualToString:@"PM25"]) {
                    [criticalPollutants setAttributedString:[[NSAttributedString alloc] initWithString:@"PM2.5"]];
                }
                if ([criticalPollutants.string isEqualToString:@"CO_8H"] || [criticalPollutants.string isEqualToString:@"CO_8h"]) {
                    [criticalPollutants setAttributedString:[[NSAttributedString alloc] initWithString:@"CO"]];
                }
                if ([criticalPollutants.string isEqualToString:@"O3_8H"] || [criticalPollutants.string isEqualToString:@"O3_8H"]) {
                    [criticalPollutants setAttributedString:[[NSAttributedString alloc] initWithString:@"O3"]];
                }
                if ([criticalPollutants length] > 2) {
                    [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(2, [criticalPollutants length] - 2)];
                }else if ([criticalPollutants.string isEqualToString:@"O3"]) {
                    [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(1, [criticalPollutants length] - 1)];
                }
                if (i == 0) {
                    [criticalAttri setAttributedString:criticalPollutants];
                }else {
                    [criticalPollutants insertAttributedString:[[NSAttributedString alloc] initWithString:@","] atIndex:0];
                    [criticalAttri appendAttributedString:criticalPollutants];
                }
            }
            [criticalAttri insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@"首要污染物："] atIndex:0];
            cell.detailTextLabel.attributedText = criticalAttri;
        }
    }else {
        cell.detailTextLabel.text = @" ";
    }
    
    
    
    
    //------------------
    if ([cell.contentView viewWithTag:50] == nil) {
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 50, 20)];
        valueLabel.font = [UIFont boldSystemFontOfSize:16];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.layer.cornerRadius = 10.0;
        valueLabel.layer.masksToBounds = YES;
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.tag = 50;
        [cell.contentView addSubview:valueLabel];
    }
    UILabel *valueLab = (UILabel *)[cell.contentView viewWithTag:50];
    switch (titleView.selectedIndex) {
        case 0:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.AQI];
            break;
        case 1:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.PM25];
            break;
        case 2:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.PM10];
            break;
        case 3:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.SO2];
            break;
        case 4:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.NO2];
            break;
        case 5:
            valueLab.text = [[Configure sharedInstance] removeDotByValue:object.O3];
            break;
        case 6:
            valueLab.text = object.CO;
            break;
        default:
            break;
    }
    valueLab.backgroundColor = [[Configure sharedInstance] getPollutionTextColor:valueLab.text withType:@[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"][titleView.selectedIndex]];
    
    if ([valueLab.text isEqualToString:@"'-'"] || [valueLab.text isEqualToString:@"'/'"]) {
        valueLab.text = @"/";
        [valueLab setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return titleView;
}

- (void)changePollutionType {
    NSSortDescriptor *sortByObject = [NSSortDescriptor sortDescriptorWithKey:@[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"][titleView.selectedIndex] ascending:NO comparator:^(id obj1, id obj2) {
        
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    [dataArray sortUsingDescriptors:[NSArray arrayWithObject:sortByObject]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TenderViewController *tender = [[TenderViewController alloc] init];
//    NSArray *array = [[[Configure sharedInstance] getAllSites] allValues];
    SiteObject *object = dataArray[indexPath.row];
    tender.siteId = object.clientid;
    tender.selecedIndex = titleView.selectedIndex;
    if (iOS7) {
        tender.automaticallyAdjustsScrollViewInsets = NO;
        tender.edgesForExtendedLayout = UIRectEdgeNone;
        tender.navigationController.navigationBar.translucent = NO;
    }
//    tender.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tender animated:YES];
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
