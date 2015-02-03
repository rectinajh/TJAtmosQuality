//
//  BMKSiteAnnotationView.m
//  AtmosQuality
//
//  Created by Tjise on 13-11-29.
//  Copyright (c) 2013年 WoshiTV. All rights reserved.
//

#import "BMKSiteAnnotationView.h"
#import "ConfigManager.h"

@implementation BMKSiteAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier siteValue:(NSString *)siteValue level:(NSString *)level {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 40*3/4, 30*3/4);
        
        self.frame = frame;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
//        [label setBackgroundColor:[[Configure sharedInstance] getPollutionTextColor:siteValue withType:self.pollutionType]];
        if ([siteValue integerValue] == 0) {
            [label setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        }
        label.text = [siteValue isEqualToString:@"0"] ? @"/" : siteValue;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        //将图层的边框设置为圆脚
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        label.tag = -10;
        [self addSubview:label];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleStr withLevel:(NSString *)level {
    UILabel *label = (UILabel *)[self viewWithTag:-10];
    label.text = titleStr;
//    [label setBackgroundColor:[[Configure sharedInstance] getPollutionTextColor:titleStr withType:self.pollutionType]];
}


- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier siteValue:(NSString *)siteValue type:(NSString *)type {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 40*3/4, 30*3/4);
        self.frame = frame;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[[Configure sharedInstance] getPollutionTextColor:siteValue withType:type]];
        if ([siteValue integerValue] == 0) {
            [label setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        }
        label.text = ([siteValue isEqualToString:@"0"] || [siteValue isEqualToString:@"'-'"]) ? @"/" : siteValue;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        //将图层的边框设置为圆脚
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor];
        label.tag = -10;
        [self addSubview:label];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleStr withType:(NSString *)type {
    UILabel *label = (UILabel *)[self viewWithTag:-10];
    label.text = titleStr;
    [label setBackgroundColor:[[Configure sharedInstance] getPollutionTextColor:titleStr withType:type]];
    if ([titleStr isEqualToString:@"'-'"] || [titleStr isEqualToString:@"'/'"]) {
        label.text = @"/";
        [label setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
