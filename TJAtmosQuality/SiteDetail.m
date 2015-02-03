//
//  SiteDetail.m
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SiteDetail.h"
#import "ConfigManager.h"
#import "PollutionValueView.h"
#import "SiteObject.h"

#import "PromptView.h"

@implementation SiteDetail

@synthesize siteId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.siteId = nil;
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        scroll.contentSize = CGSizeMake(CGRectGetWidth(frame), 568 + 250);
        scroll.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
        scroll.bounces = NO;
        scroll.tag = 1000;
        [self addSubview:scroll];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, scroll.contentSize.height)];
        bgView.image = [UIImage imageNamed:@"bg_none"];
        [scroll addSubview:bgView];
        self.bgImageView = bgView;
        
        
        //--------
        UILabel *stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 110, 40)];
        stationNameLabel.textColor = [UIColor whiteColor];
        stationNameLabel.font = [UIFont boldSystemFontOfSize:28];
        stationNameLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:stationNameLabel];
        self.stationName = stationNameLabel;
        //--------
        UILabel *quyudexLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 60, 20)];
        quyudexLabel.textColor = [UIColor lightGrayColor];
        quyudexLabel.font = [UIFont boldSystemFontOfSize:14];
        quyudexLabel.textAlignment = NSTextAlignmentCenter;
        quyudexLabel.layer.cornerRadius = 10.0;
        quyudexLabel.layer.masksToBounds = YES;
        [scroll addSubview:quyudexLabel];
        self.quyudex = quyudexLabel;
        //--------
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 15)];
        statusLabel.text = @"空气质量指数/AQI";
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.font = [UIFont boldSystemFontOfSize:14];
        statusLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:statusLabel];
        //--------
        
        //--------
        UILabel *aqiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
        aqiValueLabel.font = [UIFont systemFontOfSize:80];
        aqiValueLabel.textAlignment = NSTextAlignmentCenter;
        aqiValueLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:aqiValueLabel];
        self.aqiValue = aqiValueLabel;
        //--------
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        levelLabel.textColor = [UIColor whiteColor];
        levelLabel.font = [UIFont boldSystemFontOfSize:38];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:levelLabel];
        self.level = levelLabel;
        //--------
        UILabel *criLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 280, 30)];
        criLabel.textColor = [UIColor whiteColor];
        criLabel.font = [UIFont systemFontOfSize:18];
        criLabel.textAlignment = NSTextAlignmentCenter;
        criLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:criLabel];
        self.cri = criLabel;
        //--------
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 20)];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor = [UIColor clearColor];
        [scroll addSubview:timeLabel];
        self.time = timeLabel;
        //--------
        
        for (int i = 0; i < 6; i++) {
            PollutionValueView *view = [[PollutionValueView alloc] initWithFrame:CGRectMake(10 +  15 + (i % 3) * (80 + 15), 315 + (i / 3) * (80 + 15), 80, 80)];
            view.tag = 1000 + 1 + i;
            [scroll addSubview:view];
        }
        PromptView *promptView = [[PromptView alloc] initWithFrame:CGRectMake(20, 500, 280, scroll.contentSize.height - 500)];
        [scroll addSubview:promptView];
        self.prompt = promptView;
    }
    return self;
}

- (void)applySiteData {
    NSArray *textArray = @[@"优", @"良", @"轻度污染", @"中度污染", @"重度污染", @"严重污染"];
    SiteObject *siteObj = [[[Configure sharedInstance] getAllSites] objectForKey:self.siteId];
    
    //站点名称
    CGSize size = CGSizeZero;
    if (iOS7) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:siteObj.stationName];
        NSRange range = NSMakeRange(0, attributedText.length);
        NSMutableDictionary *attributedTextDic = [NSMutableDictionary dictionaryWithDictionary:[attributedText attributesAtIndex:0 effectiveRange:&range]];
        [attributedTextDic setObject:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:30]) forKey:NSFontAttributeName];
        size = [[attributedText string] boundingRectWithSize:CGSizeMake(300, 40)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributedTextDic
                                                     context:nil].size;
    }else {
        size = [siteObj.stationName sizeWithFont:[UIFont boldSystemFontOfSize:30] constrainedToSize:CGSizeMake(300, 40) lineBreakMode:NSLineBreakByCharWrapping];
    }
    self.stationName.frame = CGRectMake(self.stationName.frame.origin.x, self.stationName.frame.origin.y, size.width, self.stationName.frame.size.height);
    self.stationName.text = siteObj.stationName;
    
    CGRect quyuFrame = self.quyudex.frame;
    quyuFrame.origin.x = self.stationName.frame.origin.x + size.width + 10;
    if ([siteObj.quyudex length] == 4) {
        quyuFrame.size.width = 75;
    }
    self.quyudex.frame = quyuFrame;
    self.quyudex.text = siteObj.quyudex;
    self.quyudex.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    self.aqiValue.text = ([siteObj.AQI isEqualToString:@"0"] || [siteObj.AQI isEqualToString:@"'-'"]) ? @"/" : [[siteObj.AQI componentsSeparatedByString:@"."] firstObject];
    self.aqiValue.textColor = [[Configure sharedInstance] getAQITextColor:self.aqiValue.text];
    
    if ([siteObj.airPollutionLevel integerValue] > 0) {
        self.level.text = [textArray objectAtIndex:[siteObj.airPollutionLevel integerValue] - 1];
        [self.prompt applyInfoDataWithLevel:siteObj.airPollutionLevel];
    }else {
        self.level.text = @"-";
        [self.prompt applyInfoDataWithLevel:@"error"];
    }
    NSArray *imgs = @[[UIImage imageNamed:@"bg_blue"], [UIImage imageNamed:@"bg_green"], [UIImage imageNamed:@"bg_brown"]];
    self.bgImageView.image = imgs[([siteObj.airPollutionLevel integerValue] - 1) / 2];
    
    //首要污染物
    NSArray *criticalArray = [siteObj.criticalPollutants componentsSeparatedByString:@"_"];
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
        if ([criticalPollutants.string isEqualToString:@"O3_8H"] || [criticalPollutants.string isEqualToString:@"O3_8h"]) {
            [criticalPollutants setAttributedString:[[NSAttributedString alloc] initWithString:@"O3"]];
        }
        if ([criticalPollutants length] > 2) {
            [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(2, [criticalPollutants length] - 2)];
        }else if ([criticalPollutants.string isEqualToString:@"O3"]) {
            [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(1, [criticalPollutants length] - 1)];
        }
        if (i == 0) {
            [criticalAttri setAttributedString:criticalPollutants];
        }else {
            [criticalPollutants insertAttributedString:[[NSAttributedString alloc] initWithString:@","] atIndex:0];
            [criticalAttri appendAttributedString:criticalPollutants];
        }
    }
    [criticalAttri insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@"首要污染物："] atIndex:0];
    self.cri.attributedText = criticalAttri;
    if ([siteObj.criticalPollutants isEqualToString:@"数据不足"] || [[criticalArray firstObject] isEqualToString:@"--"]) {
        self.cri.text = @"首要污染物：/";
    }
    
    //时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    self.time.text = [NSString stringWithFormat:@"更新时间：%@:00", [dateFormatter stringFromDate:[NSDate date]]];
    
    //污染物
    PollutionValueView *pm25View = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1001];
    [pm25View setPollutionValue:[self removeDotByValue:siteObj.PM25]];
    [pm25View setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"PM25"]];
    
    PollutionValueView *pm10View = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1002];
    [pm10View setPollutionValue:[self removeDotByValue:siteObj.PM10]];
    [pm10View setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"PM10"]];
    
    PollutionValueView *so2View = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1003];
    [so2View setPollutionValue:[self removeDotByValue:siteObj.SO2]];
    [so2View setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"SO2"]];
    
    PollutionValueView *no2View = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1004];
    [no2View setPollutionValue:[self removeDotByValue:siteObj.NO2]];
    [no2View setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"NO2"]];
    
    PollutionValueView *o3View = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1005];
    [o3View setPollutionValue:[self removeDotByValue:siteObj.O3]];
    [o3View setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"O3"]];
    
    PollutionValueView *coView = (PollutionValueView *)[[self viewWithTag:1000] viewWithTag:1006];
    [coView setPollutionValue:siteObj.CO];
    [coView setPollutionName:[[Configure sharedInstance] setAttributeForTypeString:@"CO"]];
}

- (NSString *)removeDotByValue:(NSString *)value {
    return [[value componentsSeparatedByString:@"."] firstObject];
}



@end
