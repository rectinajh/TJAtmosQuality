//
//  ListTitleView.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "ListTitleView.h"
#import "ConfigManager.h"

#define BUTTON_WIDTH 60

@implementation ListTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectedIndex = 0;
        NSArray *titles = @[@"AQI", @"PM25", @"PM10", @"SO2", @"NO2", @"O3", @"CO"];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        scroll.contentSize = CGSizeMake(BUTTON_WIDTH * [titles count], CGRectGetHeight(frame));
        scroll.contentInset = UIEdgeInsetsMake(0, 1, 0, 0);
        scroll.bounces = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.tag = 800;
        [self addSubview:scroll];
        
        indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 2, BUTTON_WIDTH, 2)];
        indicateView.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:166.0/255.0 blue:255.0/255.0 alpha:1.0];
        [scroll addSubview:indicateView];
        
        for (int i = 0; i < [titles count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(BUTTON_WIDTH * i, 0, BUTTON_WIDTH, frame.size.height)];
            [button setAttributedTitle:[[Configure sharedInstance] setAttributeForTypeString:titles[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:122.0/255.0];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [scroll addSubview:button];
            [scroll sendSubviewToBack:button];
            button.tag = 800 + 1 + i;
            
            if (i < [titles count] && i > 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BUTTON_WIDTH * i - 1, frame.size.height / 4, 2, frame.size.height / 2)];
                line.backgroundColor = [UIColor whiteColor];
                [scroll addSubview:line];
            }
        }
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect indiFrame = indicateView.frame;
        indiFrame.origin.x = (sender.tag - 800 - 1) * BUTTON_WIDTH;
        indicateView.frame = indiFrame;
    }];
    self.selectedIndex = sender.tag - 800 - 1;
    if (self.delegate) {
        [self.delegate changePollutionType];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    CGRect indiFrame = indicateView.frame;
    indiFrame.origin.x = selectedIndex * BUTTON_WIDTH;
    indicateView.frame = indiFrame;
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
