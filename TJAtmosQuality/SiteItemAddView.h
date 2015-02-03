//
//  SiteItemAddView.h
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SiteItemAddViewDelegate <NSObject>

- (void)addItemAction;

@end

@interface SiteItemAddView : UIView

@property (assign, nonatomic) id<SiteItemAddViewDelegate> delegate;

@end
