//
//  CustomTabBarController.m
//  AtmosQuality
//
//  Created by Tjise on 13-11-15.
//  Copyright (c) 2013年 WoshiTV. All rights reserved.
//

#import "CustomTabBarController.h"
#import "ConfigManager.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *imgArray = @[@[@"实况按钮", @"实况按钮按下"], @[@"预报按钮", @"预报按钮按下"], @[@"地图按钮", @"地图按钮按下"], @[@"设置按钮", @"设置按钮按下"]];
    int index = 0;
    for (int i = 0; i < [self.tabBar.subviews count]; i++) {
        UIView *sub = [self.tabBar.subviews objectAtIndex:i];
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            NSArray *imgs = [imgArray objectAtIndex:index];
            index += 1;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 + SCREEN_WIDTH * (index - 1) / 4, 0, SCREEN_WIDTH / 4, sub.frame.size.height)];
            button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            [button setTintColor:[UIColor clearColor]];
            [button setBackgroundColor:[UIColor clearColor]];
            
//            [button setBackgroundImage:[UIImage imageNamed:[imgs objectAtIndex:0]] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateSelected | UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[imgs objectAtIndex:0]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateSelected | UIControlStateHighlighted];
            
            
            
            button.adjustsImageWhenHighlighted = NO;
            button.adjustsImageWhenDisabled = NO;
            button.contentMode = UIViewContentModeScaleAspectFit;
            button.tag = index;
            [button addTarget:self action:@selector(tabButtonItemAction:) forControlEvents:UIControlEventTouchDown];
            [self.tabBar addSubview:button];
            if (index == 1) {
//                [button setBackgroundImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)tabButtonItemAction:(UIButton *)sender {
    NSArray *imgArray = @[@[@"实况按钮", @"实况按钮按下"], @[@"预报按钮", @"预报按钮按下"], @[@"地图按钮", @"地图按钮按下"], @[@"设置按钮", @"设置按钮按下"]];
    NSArray *imgs = [imgArray objectAtIndex:sender.tag - 1];
//    [sender setBackgroundImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:[imgs lastObject]] forState:UIControlStateNormal];
    for (UIView *sub in self.tabBar.subviews) {
        if ([sub isKindOfClass:[UIButton class]] && ![sub isEqual:sender]) {
            UIButton *button = (UIButton *)sub;
            NSArray *btnArray = [imgArray objectAtIndex:button.tag - 1];
//            [button setBackgroundImage:[UIImage imageNamed:[btnArray objectAtIndex:0]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[btnArray objectAtIndex:0]] forState:UIControlStateNormal];
        }
    }
    self.selectedIndex = sender.tag - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
