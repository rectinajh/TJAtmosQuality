//
//  AQExponentView.h
//  AtmosQuality
//
//  Created by LiWei on 14-7-16.
//  Copyright (c) 2014年 WoshiTV. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSindex 100

@interface AQExponentView : UIScrollView {
    CAGradientLayer *gradient;
}

@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) NSArray *pillars;
@property (strong, nonatomic) NSArray *fillColors;
@property (assign, nonatomic) NSInteger yMaxValue;
@property (assign, nonatomic) BOOL shouldFloat;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

- (void)setPoints:(NSArray *)points withYMaxValue:(NSInteger)yMaxValue;
- (void)setPillars:(NSArray *)pillarValues withYMaxValue:(NSInteger)yMaxValue;

- (void)setVercitalLine:(NSArray *)dataArray;

@end
