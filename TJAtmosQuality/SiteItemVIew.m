//
//  SiteItemVIew.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "SiteItemVIew.h"
#import "ConfigManager.h"

@implementation SiteItemVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.numberOfLines = 0;
//        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
        [button addGestureRecognizer:longPress];
        
        button.tag = 20;
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, frame.size.width - 25, 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = BLACK_COLOR;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 21;
        [self addSubview:label];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setFrame:CGRectMake(frame.size.width - 20, 5, 20, 20)];
        [delete setImage:[UIImage imageNamed:@"add-del"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = 22;
        [self addSubview:delete];
        delete.hidden = YES;
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hideAllDeleteBtn)] && [self.delegate hideAllDeleteBtn]) {
        [self.delegate hideAllDeleteBtn];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWSITENOTIFATION" object:[NSNumber numberWithInteger:self.tag]];
    if ([self.delegate respondsToSelector:@selector(popViewController)]) {
        [self.delegate popViewController];
    }
}

- (void)setSiteName:(NSString *)siteName {
    UIButton *button = (UIButton *)[self viewWithTag:20];
    [button setTitle:siteName forState:UIControlStateNormal];
}
- (void)setSiteRegion:(NSString *)siteRegion {
    UILabel *label = (UILabel *)[self viewWithTag:21];
    label.text = siteRegion;
}

- (void)longPressAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETENOTIFATION" object:nil];
}

- (void)showDeleteButton:(BOOL)isShow {
    [self viewWithTag:22].hidden = !isShow;
}

- (void)deleteAction:(UIButton *)sender {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"siteIds"]];
    [array removeObject:self.siteId];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"siteIds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ITEMS_NOTIFATION" object:nil];    
    
    if (self.delegate) {
        [self.delegate resetItemsView:self.tag];
    }
    [self removeFromSuperview];
}

@end
