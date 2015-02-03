//
//  ListTitleView.h
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListTitleDelegate <NSObject>

- (void)changePollutionType;

@end

@interface ListTitleView : UIView {
    UIView *indicateView;
}

@property (assign, nonatomic) id<ListTitleDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
