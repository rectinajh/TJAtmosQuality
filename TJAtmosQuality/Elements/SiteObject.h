//
//  SiteObject.h
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteObject : NSObject

@property (strong, nonatomic) NSString *AQI;
@property (strong, nonatomic) NSString *PM25;
@property (strong, nonatomic) NSString *PM25_24H;
@property (strong, nonatomic) NSString *PM10;
@property (strong, nonatomic) NSString *PM10_24H;
@property (strong, nonatomic) NSString *SO2;
@property (strong, nonatomic) NSString *SO2_24H;
@property (strong, nonatomic) NSString *NO2;
@property (strong, nonatomic) NSString *NO2_24H;
@property (strong, nonatomic) NSString *CO;
@property (strong, nonatomic) NSString *CO_24H;
@property (strong, nonatomic) NSString *O3;
@property (strong, nonatomic) NSString *O3_8H;
@property (strong, nonatomic) NSString *clientid;
@property (strong, nonatomic) NSString *datetime;
@property (strong, nonatomic) NSString *criticalPollutants;
@property (strong, nonatomic) NSString *airPollutionLevel;


@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *quyudex;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end
