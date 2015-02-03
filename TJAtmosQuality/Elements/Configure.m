//
//  Configure.m
//  WeChatOpenfire
//
//  Created by LiWei on 14-3-24.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "Configure.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>
#import "SiteObject.h"

@implementation Configure

@synthesize location;
@synthesize siteId;

+ (Configure *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (NSDictionary *)getExponentDicWithYMax:(NSString *)yMaxValue  withType:(NSString *)keyType {
    if (exponentDic == nil) {
        exponentDic = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    if ([keyType isEqualToString:@"AQI"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"50", @"100", @"150", @"200", @"300", @"400", @"500"] maxValue:yMaxValue] forKey:@"AQI"];
    }else if ([keyType isEqualToString:@"SO2"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"150", @"500", @"650", @"800", @"1600", @"2100", @"2620"] maxValue:yMaxValue] forKey:@"SO2"];
    }else if ([keyType isEqualToString:@"NO2"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"100", @"200", @"700", @"1200", @"2340", @"3090", @"3840"] maxValue:yMaxValue] forKey:@"NO2"];
    }else if ([keyType isEqualToString:@"CO"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"5", @"10", @"35", @"60", @"90", @"120", @"150"] maxValue:yMaxValue] forKey:@"CO"];
    }else if ([keyType isEqualToString:@"PM25"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"35", @"75", @"115", @"150", @"250", @"350"] maxValue:yMaxValue] forKey:@"PM25"];
    }else if ([keyType isEqualToString:@"PM10"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"50", @"150", @"250", @"350", @"420", @"500"] maxValue:yMaxValue] forKey:@"PM10"];
    }else if ([keyType isEqualToString:@"O3"]) {
        [exponentDic setObject:[self compareMaxValue:@[@"160", @"200", @"300", @"400", @"800", @"1000", @"1200"] maxValue:yMaxValue] forKey:@"O3"];
    }
    return exponentDic;
}

- (NSArray *)compareMaxValue:(NSArray *)array maxValue:(NSString *)maxValue {
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < [array count]; i++) {
        NSInteger value = [[array objectAtIndex:i] integerValue];
        if (value > [maxValue integerValue]) {
            [mArray setArray:[array subarrayWithRange:NSMakeRange(0, i + 1)]];
            break;
        }
    }
    return mArray;
}

- (void)setAQSites:(NSArray *)newSites {
    if (exponentDic == nil) {
        aqSiteDic = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    for (int i = 0; i < [newSites count]; i++) {
        SiteObject *site = newSites[i];
        [aqSiteDic setObject:site forKey:site.clientid];
    }
}

- (NSDictionary *)getAllSites {
    return aqSiteDic;
}

- (void)updateSitesArray:(NSArray *)siteArray {
    for (int i = 0; i < [siteArray count]; i++) {
        SiteObject *newObj = siteArray[i];
        SiteObject *object = [aqSiteDic objectForKey:newObj.clientid];
        object.AQI = newObj.AQI;
        object.PM10 = newObj.PM10;
        object.PM10_24H = newObj.PM10_24H;
        object.PM25 = newObj.PM25;
        object.PM25_24H = newObj.PM25_24H;
        object.SO2 = newObj.SO2;
        object.SO2_24H = newObj.SO2_24H;
        object.NO2 = newObj.NO2;
        object.NO2_24H = newObj.SO2_24H;
        object.CO = newObj.CO;
        object.CO_24H = newObj.CO_24H;
        object.O3 = newObj.O3;
        object.O3_8H = newObj.O3_8H;
        object.airPollutionLevel = newObj.airPollutionLevel;
        object.datetime = newObj.datetime;
        object.CriticalPollutants = newObj.criticalPollutants;
    }
}




- (NSAttributedString *)setAttributeForUintString:(NSString *)string {
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:string];
    if ([titleText.string hasPrefix:@"PM2.5"]) {
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(2, 3)];
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, (__bridge id)((__bridge CFNumberRef)[NSNumber numberWithInt:3]), kCTSuperscriptAttributeName, nil] range:NSMakeRange([titleText length] - 2, 1)];
    }else if ([titleText.string hasPrefix:@"PM10"]) {
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(2, 2)];
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, (__bridge id)((__bridge CFNumberRef)[NSNumber numberWithInt:3]), kCTSuperscriptAttributeName, nil] range:NSMakeRange([titleText length] - 2, 1)];
    }else if ([titleText.string hasPrefix:@"SO2"] || [titleText.string hasPrefix:@"NO2"]) {
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(2, 1)];
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, (__bridge id)((__bridge CFNumberRef)[NSNumber numberWithInt:3]), kCTSuperscriptAttributeName, nil] range:NSMakeRange([titleText length] - 2, 1)];
    }else if ([titleText.string hasPrefix:@"O3"]) {
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, nil] range:NSMakeRange(1, 1)];
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, (__bridge id)((__bridge CFNumberRef)[NSNumber numberWithInt:3]), kCTSuperscriptAttributeName, nil] range:NSMakeRange([titleText length] - 2, 1)];
    }else if ([titleText.string hasPrefix:@"CO"]) {
        [titleText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:6]), NSFontAttributeName, (__bridge id)((__bridge CFNumberRef)[NSNumber numberWithInt:3]), kCTSuperscriptAttributeName, nil] range:NSMakeRange([titleText length] - 2, 1)];
    }
    return (NSAttributedString *)titleText;
}

- (NSAttributedString *)setAttributeForTypeString:(NSString *)string {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    if ([attString.string isEqualToString:@"AQI"]) {
        return attString;
    }
    if ([attString.string isEqualToString:@"PM25"]) {
        [attString setAttributedString:[[NSAttributedString alloc] initWithString:@"PM2.5"]];
    }
    if ([attString length] > 2) {
        [attString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(2, [attString length] - 2)];
    }else if ([attString.string isEqualToString:@"O3"]) {
        [attString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(1, [attString length] - 1)];
    }
    return attString;
}

- (NSInteger)getAirPollutionLevel:(NSString *)value byType:(NSInteger)type {
    if ([value floatValue] <= 0.0) {
        return 0;
    }
    float pullutionValue = [value floatValue];
    switch (type) {
        case 0://AQI
            if (pullutionValue <= 200) {
                return pullutionValue / 50 + 1;
            }else if (pullutionValue <= 300) {
                return 5;
            }else {
                return 6;
            }
            break;
        case 1://PM25
            if (pullutionValue <= 35) {
                return 1;
            }else if (pullutionValue <= 75) {
                return 2;
            }else if (pullutionValue <= 115) {
                return 3;
            }else if (pullutionValue <= 150) {
                return 4;
            }else if (pullutionValue <= 250) {
                return 5;
            }else {
                return 6;
            }
            break;
        case 2://PM10
            if (pullutionValue <= 50) {
                return 1;
            }else if (pullutionValue <= 150) {
                return 2;
            }else if (pullutionValue <= 250) {
                return 3;
            }else if (pullutionValue <= 350) {
                return 4;
            }else if (pullutionValue <= 420) {
                return 5;
            }else {
                return 6;
            }
            break;
        case 3://SO2
            if (pullutionValue <= 50) {
                return 1;
            }else if (pullutionValue <= 150) {
                return 2;
            }else if (pullutionValue <= 500) {
                return 3;
            }else if (pullutionValue <= 650) {
                return 4;
            }else if (pullutionValue <= 800) {
                return 5;
            }else {
                return 6;
            }
            break;
        case 4://NO2
            if (pullutionValue <= 100) {
                return 1;
            }else if (pullutionValue <= 200) {
                return 2;
            }else if (pullutionValue <= 700) {
                return 3;
            }else if (pullutionValue <= 1200) {
                return 4;
            }else {
                return 6;
            }
            break;
        case 5://O3
            if (pullutionValue <= 160) {
                return 1;
            }else if (pullutionValue <= 200) {
                return 2;
            }else if (pullutionValue <= 300) {
                return 3;
            }else if (pullutionValue <= 400) {
                return 4;
            }else if (pullutionValue <= 800) {
                return 5;
            }else {
                return 6;
            }
            break;
            
        case 6://CO
            if (pullutionValue <= 5) {
                return 1;
            }else if (pullutionValue <= 10) {
                return 2;
            }else if (pullutionValue <= 35) {
                return 3;
            }else if (pullutionValue <= 60) {
                return 4;
            }else if (pullutionValue <= 90) {
                return 5;
            }else {
                return 6;
            }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIColor *)getPollutionTextColor:(NSString *)value withType:(NSString *)pollutionType {
    NSArray *titles = @[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"];
    //绿，黄，橙，红
    NSArray *colors = @[[UIColor colorWithRed:0 green:228.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:153.0/255.0 green:0 blue:76.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:126.0/255.0 green:0 blue:35.0/255.0 alpha:1.0]];
    NSInteger pullutionLevel = [self getAirPollutionLevel:value byType:[titles indexOfObject:pollutionType]];
    if (pullutionLevel == 0 || [value isEqualToString:@"/"] || [value isEqualToString:@"'-'"]) {
        return [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    }
    return colors[pullutionLevel - 1];
}

- (NSString *)removeDotByValue:(NSString *)value {
    return [[value componentsSeparatedByString:@"."] firstObject];
}

- (UIColor *)getAQITextColor:(NSString *)aqiValue {
    if ([aqiValue isEqualToString:@"0"] || [aqiValue isEqualToString:@"/"]) {
        return [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    }
    NSArray *colors = @[[UIColor colorWithRed:0 green:228.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:153.0/255.0 green:0 blue:76.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:126.0/255.0 green:0 blue:35.0/255.0 alpha:1.0]];
    NSInteger pullutionType = [self getAirPollutionLevel:aqiValue byType:0];
    return colors[pullutionType - 1];
}

@end
