//
//  MapViewController.m
//  EnterpriseModel
//
//  Created by Tjise on 13-10-12.
//  Copyright (c) 2013年 WoshiTV. All rights reserved.
//

#import "MapViewController.h"
#import "ConfigManager.h"
#import "ListTitleView.h"
#import "SiteObject.h"

#import "BMKSiteAnnotationView.h"
#import "TenderViewController.h"
#import "AFAppDotNetAPIClient.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@interface MapViewController () <ListTitleDelegate> {
    ListTitleView *titleView;
}

@end

@implementation MapViewController

@synthesize endLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView = [[ListTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    
    if (iPhone5 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 44);
    }
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKCoordinateRegion region;
    region.center.latitude  = 39.09812;
    region.center.longitude = 117.15778;
    _mapView.region = region;
    _mapView.zoomLevel = 10;
    
    exponentType = 0;
    isAlreadyLocation = NO;
    
    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc] init];
    
//    dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self startDownloadOfflineMapWithCityId:332];//天津id=332
}

- (void)startDownloadOfflineMapWithCityId:(float)cityId {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"Tian_Jin_Shi_332_hv_baidu.zip"];

    if([fileManager fileExistsAtPath:txtPath] == NO){
        NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"Tian_Jin_Shi_332_hv_baidu" ofType:@"zip"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    NSLog(@"path == %@", txtPath);
    
    if ([_offlineMap scan:NO]) {//开始下载离线包
//        NSLog(@"123213213");
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//        hud.labelText = @"正在下载离线地图包";
//        hud.tag = 888;
//        [hud show:YES];
    }
    
}

- (IBAction)loadMapViewData {
    NSArray *sites = [[[Configure sharedInstance] getAllSites] allValues];
    for (int i = 0; i < [sites count]; i++) {
        SiteObject *object = [sites objectAtIndex:i];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [object.lat floatValue];
        coor.longitude = [object.lng floatValue];;
        annotation.coordinate = coor;
        annotation.title = object.stationName;
        [_mapView addAnnotation:annotation];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _offlineMap.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getMyBundlePath1:(NSString *)filename {
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation {
    if (!isAlreadyLocation) {
        isAlreadyLocation = YES;
        BMKCoordinateRegion region;
        region.center.latitude  = userLocation.location.coordinate.latitude;
        region.center.longitude = userLocation.location.coordinate.longitude;
        _mapView.region = region;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    SiteObject *object = [[[[Configure sharedInstance] getAllSites] allValues] objectAtIndex:[[_mapView annotations] indexOfObject:annotation]];
    NSString *pullutionValue = nil;
    switch (titleView.selectedIndex) {
        case 0:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.AQI];
            break;
        case 1:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.PM25];
            break;
        case 2:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.PM10];
            break;
        case 3:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.SO2];
            break;
        case 4:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.NO2];
            break;
        case 5:
            pullutionValue = [[Configure sharedInstance] removeDotByValue:object.O3];
            break;
        case 6:
            pullutionValue = object.CO;
            break;
        default:
            break;
    }
    BMKSiteAnnotationView *annotationView = [[BMKSiteAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation" siteValue:pullutionValue type:@[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"][titleView.selectedIndex]];
    annotationView.tag = [[_mapView annotations] indexOfObject:annotation];
    return annotationView;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    if ([view.reuseIdentifier isEqualToString:@"annotation"]) {
//        NSDictionary *dic = [dataArray objectAtIndex:view.tag];
//        SingleSiteViewController *site = [[SingleSiteViewController alloc] init];
//        site.siteId = [dic objectForKey:@"clientid"];
//        [self.navigationController pushViewController:site animated:YES];
        TenderViewController *tender = [[TenderViewController alloc] init];
        NSArray *array = [[[Configure sharedInstance] getAllSites] allValues];
//        NSLog(@"000000 = %d", [[mapView annotations] indexOfObject:view.annotation]);
//        NSLog(@"11111 = %@", [mapView annotations]);
        SiteObject *object = array[[[_mapView annotations] indexOfObject:view.annotation]];
        tender.siteId = object.clientid;
        tender.selecedIndex = titleView.selectedIndex;
        if (iOS7) {
            tender.automaticallyAdjustsScrollViewInsets = NO;
            tender.edgesForExtendedLayout = UIRectEdgeNone;
            tender.navigationController.navigationBar.translucent = NO;
        }
//        tender.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tender animated:YES];
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
//    CGSize size = [[view.annotation title] sizeWithAttributes:[NSDictionary dictionaryWithObject:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:14]) forKey:NSFontAttributeName]];
//
//    for (UIView *sub in view.paopaoView.subviews) {
//        if ([[sub description] hasPrefix:@"<PaopaoButton"]) {
//            for (UIView *sub1 in sub.subviews) {
//                if ([[sub1 description] hasPrefix:@"<UILabel:"]) {
//                    UILabel *label = (UILabel *)sub1;
//                    label.textColor = [UIColor blackColor];
////                    label.frame = CGRectMake((label.superview.frame.size.width - size.width) / 2 - 5, 1, size.width, 20);
//                    label.frame = CGRectMake((label.superview.frame.size.width - size.width) / 2 - 5, 1, size.width, 20);
//                    label.font = [UIFont systemFontOfSize:14];
//                    label.contentMode = UIViewContentModeCenter;
//                }
//            }
//        }
//    }
}

- (void)changePollutionType {
    for (int i = 0; i < [[_mapView annotations] count]; i++) {
        BMKPointAnnotation *point = (BMKPointAnnotation *)[[_mapView annotations] objectAtIndex:i];
        BMKSiteAnnotationView *annotation = (BMKSiteAnnotationView *)[_mapView viewForAnnotation:point];
        
        SiteObject *object = [[[[Configure sharedInstance] getAllSites] allValues] objectAtIndex:i];
        NSString *pullutionValue = nil;
        switch (titleView.selectedIndex) {
            case 0:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.AQI];
                break;
            case 1:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.PM25];
                break;
            case 2:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.PM10];
                break;
            case 3:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.SO2];
                break;
            case 4:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.NO2];
                break;
            case 5:
                pullutionValue = [[Configure sharedInstance] removeDotByValue:object.O3];
                break;
            case 6:
                pullutionValue = object.CO;
                break;
            default:
                break;
        }
        
        [annotation setTitleString:pullutionValue withType:@[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"][titleView.selectedIndex]];
    }
}

#pragma -

//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:888];
        hud.labelText = [NSString stringWithFormat:@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio];
//        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
//        if(state==0)
//        {
//            [self showImportMesg:state];
//        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        [self loadMapViewData];
        //导入成功state个离线包，导入成功后会回调此类型
    }
    
}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
	NSString *string = nil;
	if (nSize<1024)
	{
		string = [NSString stringWithFormat:@"%dB", nSize];
	}
	else if (nSize<1048576)
	{
		string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
	}
	else if (nSize<1073741824)
	{
		if ((nSize%1048576)== 0 )
        {
			string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
		else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
	}
	else	// >1G
	{
		string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
	}
	
	return string;
}


@end
