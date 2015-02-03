//
//  Configure.h
//  WeChatOpenfire
//
//  Created by LiWei on 14-3-24.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Configure : NSObject <CLLocationManagerDelegate> {
    CLLocationManager   *locationManager;
    
    NSMutableDictionary *exponentDic;
        
    NSMutableDictionary *aqSiteDic;
}

@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) NSString *siteId;

+ (Configure *)sharedInstance;

- (NSDictionary *)getExponentDicWithYMax:(NSString *)yMaxValue withType:(NSString *)keyType;

- (void)setAQSites:(NSArray *)newSites;
- (NSDictionary *)getAllSites;
- (void)updateSitesArray:(NSArray *)siteArray;

- (NSAttributedString *)setAttributeForUintString:(NSString *)string;
- (NSAttributedString *)setAttributeForTypeString:(NSString *)string;
- (NSInteger)getAirPollutionLevel:(NSString *)value byType:(NSInteger)type;

- (UIColor *)getPollutionTextColor:(NSString *)value withType:(NSString *)pollutionType;
- (NSString *)removeDotByValue:(NSString *)value;

- (UIColor *)getAQITextColor:(NSString *)aqiValue;

@end
