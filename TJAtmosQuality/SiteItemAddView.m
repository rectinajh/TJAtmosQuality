//
//  SiteItemAddView.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SiteItemAddView.h"

@implementation SiteItemAddView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [button setImage:[UIImage imageNamed:@"add_gray"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20;
        [self addSubview:button];
    }
    return self;
}

- (void)addAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addItemAction];
    }
}

@end
