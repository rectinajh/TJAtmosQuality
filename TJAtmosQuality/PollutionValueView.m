//
//  PollutionValueView.m
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "PollutionValueView.h"
#import "ConfigManager.h"

@implementation PollutionValueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = frame.size.height / 2;
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 2 / 3)];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:30];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.tag = 1100;
        [self addSubview:valueLabel];
        
        UIView *levelView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 4, frame.size.height * 3 / 5, frame.size.width / 2, 3)];
        levelView.tag = 1101;
        [self addSubview:levelView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 3 / 5, frame.size.width, frame.size.height / 3)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag = 1102;
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)setPollutionValue:(NSString *)value {
    UILabel *valueLabel = (UILabel *)[self viewWithTag:1100];
    valueLabel.text = value;
    if ([value isEqualToString:@"'-'"] || [value isEqualToString:@"'/'"]) {
        valueLabel.text = @"/";
    }
}

- (void)setPollutionName:(NSAttributedString *)name {
    UILabel *nameLabel = (UILabel *)[self viewWithTag:1102];
    nameLabel.attributedText = name;
    
    UIView *levelView = (UIView *)[self viewWithTag:1101];
    UILabel *valueLabel = (UILabel *)[self viewWithTag:1100];
    if ([valueLabel.text isEqualToString:@"/"]) {
        [levelView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        return;
    }
    
    NSArray *colors = @[[UIColor colorWithRed:0 green:228.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:153.0/255.0 green:0 blue:76.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:126.0/255.0 green:0 blue:35.0/255.0 alpha:1.0]];
    NSArray *types = @[@"AQI", @"PM2.5", @"PM10", @"SO2", @"NO2", @"O3", @"CO"];
    NSInteger pullutionType = [[Configure sharedInstance] getAirPollutionLevel:valueLabel.text byType:[types indexOfObject:name.string]];
    if (pullutionType > 0) {
        [levelView setBackgroundColor:colors[pullutionType - 1]];
    }
}

@end
