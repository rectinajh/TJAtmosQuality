//
//  MapViewController.h
//  EnterpriseModel
//
//  Created by Tjise on 13-10-12.
//  Copyright (c) 2013年 WoshiTV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MBProgressHUD.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate, BMKOfflineMapDelegate, UIActionSheetDelegate> {
    IBOutlet BMKMapView* _mapView;
    BMKOfflineMap* _offlineMap;
    
    BOOL isAlreadyLocation;
    NSInteger exponentType;
//    NSMutableArray *dataArray;
}

@property (nonatomic) CLLocationCoordinate2D endLocation;

- (IBAction)loadMapViewData;
//- (IBAction)reloadMap:(id)sender;
//- (IBAction)siteListAction:(UIBarButtonItem *)sender;

@end
