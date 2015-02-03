//
//  SiteObject.m
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SiteObject.h"

@implementation SiteObject

@synthesize AQI;
@synthesize PM25;
@synthesize PM25_24H;
@synthesize PM10;
@synthesize PM10_24H;
@synthesize SO2;
@synthesize SO2_24H;
@synthesize NO2;
@synthesize NO2_24H;
@synthesize CO;
@synthesize CO_24H;
@synthesize O3;
@synthesize O3_8H;
@synthesize clientid;
@synthesize datetime;
@synthesize criticalPollutants;
@synthesize airPollutionLevel;


@synthesize stationName;
@synthesize quyudex;
@synthesize lat;
@synthesize lng;

- (NSString *)description {
    [super description];
//    NSLog(@"AQI = %@, PM25 = %@, PM25_24H = %@, PM10 = %@, PM10_24H = %@, SO2 = %@, SO2_24H = %@, NO2 = %@, NO2_24H = %@, CO = %@, CO_24H = %@, O3 = %@, O3_8H = %@, clientid = %@, datetime = %@, CriticalPollutants = %@", self.AQI, self.PM25, self.PM25_24H, self.PM10, self.PM10_24H, self.SO2, self.SO2_24H, self.NO2, self.NO2_24H, self.CO, self.CO_24H, self.O3, self.O3_8H, self.clientid, self.datetime, self.CriticalPollutants);
    return [NSString stringWithFormat:@"AQI = %@, PM25 = %@, PM25_24H = %@, PM10 = %@, PM10_24H = %@, SO2 = %@, SO2_24H = %@, NO2 = %@, NO2_24H = %@, CO = %@, CO_24H = %@, O3 = %@, O3_8H = %@, clientid = %@, datetime = %@, criticalPollutants = %@, airPollutionLevel = %@, stationName = %@, quyudex = %@, lat = %@, lng = %@", self.AQI, self.PM25, self.PM25_24H, self.PM10, self.PM10_24H, self.SO2, self.SO2_24H, self.NO2, self.NO2_24H, self.CO, self.CO_24H, self.O3, self.O3_8H, self.clientid, self.datetime, self.criticalPollutants, self.airPollutionLevel, self.stationName, self.quyudex, self.lat, self.lng];
}

@end
