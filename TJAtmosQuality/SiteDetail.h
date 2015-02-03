//
//  SiteDetail.h
//  TJAQ
//
//  Created by LiWei on 14-7-30.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromptView;

@interface SiteDetail : UIView

@property (nonatomic, strong) NSString *siteId;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *stationName;
@property (nonatomic, strong) UILabel *quyudex;
@property (nonatomic, strong) UILabel *aqiValue;
@property (nonatomic, strong) UILabel *level;
@property (nonatomic, strong) UILabel *cri;
@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) PromptView *prompt;

- (void)applySiteData;

@end
