//
//  SiteListViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SiteListViewController.h"
#import "ConfigManager.h"
#import "SiteObject.h"

@interface SiteListViewController () {
    NSMutableDictionary *dataDic;
}

@end

@implementation SiteListViewController

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
    
    self.tableView.tableFooterView = [UIView new];
    
    dataDic = [[NSMutableDictionary alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:[[Configure sharedInstance] getAllSites]]];
    NSArray *defaultSites = [[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"];
    [dataDic removeObjectsForKeys:defaultSites];
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
    return [[dataDic allValues] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row % 2 != 0) {
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    SiteObject *object = [[dataDic allValues] objectAtIndex:indexPath.row];
    cell.textLabel.text = object.stationName;
    cell.detailTextLabel.text = object.quyudex;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SiteObject *object = [[dataDic allValues] objectAtIndex:indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"]];
    [array addObject:object.clientid];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"siteIds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHNOTIFATION" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
