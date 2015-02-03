//
//  SiteItemVIew.h
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SiteItemVIewDelegate <NSObject>

- (void)resetItemsView:(NSInteger)deleteTag;
- (BOOL)hideAllDeleteBtn;

@optional

- (void)popViewController;

@end

@interface SiteItemVIew : UIView

@property (assign, nonatomic) id<SiteItemVIewDelegate> delegate;
@property (strong, nonatomic) NSString *siteId;

- (void)setSiteName:(NSString *)siteName;
- (void)setSiteRegion:(NSString *)siteRegion;
- (void)showDeleteButton:(BOOL)isShow;

@end
