//
//  ConfigManager.h
//  WeChatOpenfire
//
//  Created by LiWei on 14-3-11.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#ifndef WeChatOpenfire_ConfigManager_h
#define WeChatOpenfire_ConfigManager_h
#endif

#import "Configure.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0 ? YES : NO)

#define SERVER_URL @"http://60.28.63.213:9000"


#define EXPONENT_DATA @"AQI  空气质量指数", @"PM2.5  细颗粒物(μg/m3)", @"PM10  可吸入细颗粒物(μg/m3)", @"SO2  二氧化硫(μg/m3)", @"NO2  二氧化氮(μg/m3)", @"O3  臭氧(μg/m3)", @"CO  一氧化碳(mg/m3)"

#define EXPONENT_TYPE @"AQI,PM25,PM10,SO2,NO2,O3,CO"
#define EXPONENT_DETAIL @"空气质量指数,细颗粒物(μg/m3),可吸入细颗粒物(μg/m3),二氧化硫(μg/m3),二氧化氮(μg/m3),臭氧(μg/m3),一氧化碳(mg/m3)"

#define BLACK_COLOR [UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]


// ---------------- 尺寸 --------------------
#pragma mark -
#pragma mark 尺寸类

/**
 * 获取屏幕宽度
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

/**
 * 获取屏幕高度
 */
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// -----------------------------------------