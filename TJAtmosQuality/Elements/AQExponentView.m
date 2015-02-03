//
//  AQExponentView.m
//  AtmosQuality
//
//  Created by LiWei on 14-7-16.
//  Copyright (c) 2014年 WoshiTV. All rights reserved.
//

#import "AQExponentView.h"
#import "ConfigManager.h"

#define PillarWIDTH 25
#define GRAPH_HEIGHT (self.frame.size.height - 30.0)

#define MAX_PADHEIGHT 14.0

#define LINE_COLOR [UIColor colorWithRed:0 green:150.0/255.0 blue:255.0/255.0 alpha:150.0/255.0]

@implementation AQExponentView

static NSInteger startIndex = 0;

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(frame.size.width * 3 + 10, frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        
        self.shouldFloat = NO;

        //图表时间节点群
        NSArray *numbers = @[@0, @5, @11, @17, @23];
        for (int i = 0; i < [numbers count]; i++) {
            UILabel *timestamp = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, PillarWIDTH + 15 * 2, 20)];
            timestamp.textColor = BLACK_COLOR;
            timestamp.font = [UIFont systemFontOfSize:14];
            timestamp.textAlignment = NSTextAlignmentCenter;
            timestamp.tag = 20 + i;
            [self addSubview:timestamp];
            NSRange rang = NSMakeRange(11, 2);
            if (i == 0 || i == 4) {
                rang.location = 5;
                rang.length = 8;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
            
            switch (i) {
                case 0:
                    timestamp.text = [NSString stringWithFormat:@"%@:00", [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600 * (23 - 0)]] substringWithRange:rang]];
                    break;
                case 1:
                    timestamp.text = [NSString stringWithFormat:@"%@:00", [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600 * (23 - 5)]] substringWithRange:rang]];
                    break;
                case 2:
                    timestamp.text = [NSString stringWithFormat:@"%@:00", [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600 * (23 - 11)]] substringWithRange:rang]];
                    break;
                case 3:
                    timestamp.text = [NSString stringWithFormat:@"%@:00", [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600 * (23 - 17)]] substringWithRange:rang]];
                    break;
                case 4:
                    timestamp.text = [NSString stringWithFormat:@"%@:00", [[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]] substringWithRange:rang]];
                    break;
                default:
                    break;
            }
            [timestamp setCenter:CGPointMake(25 + [numbers[i] integerValue] * (15 + PillarWIDTH), timestamp.center.y)];
            if (i == 0 || i == 4) {
                CGRect tFrame = timestamp.frame;
                tFrame.size.width += 30;
                i == 0 ? (tFrame.origin.x += 5) : (tFrame.origin.x -= 35);
                timestamp.frame = tFrame;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, GRAPH_HEIGHT, self.contentSize.width, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [self addSubview:line];
        //--------------------------------
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    ((CAShapeLayer *)self.layer).fillColor = [UIColor clearColor].CGColor;
////    ((CAShapeLayer *)self.layer).strokeColor = [UIColor colorWithRed:0 green:150.0/255.0 blue:1 alpha:150.0/255.0].CGColor;
//    ((CAShapeLayer *)self.layer).strokeColor = [UIColor redColor].CGColor;//lineWidth
//    ((CAShapeLayer *)self.layer).lineWidth = 4.0f;
//    ((CAShapeLayer *)self.layer).backgroundColor = [[UIColor whiteColor] CGColor];
//    ((CAShapeLayer *)self.layer).opacity = 1.0f;
//    ((CAShapeLayer *)self.layer).allowsGroupOpacity = YES;
//    if (_pillars) {
//        ((CAShapeLayer *)self.layer).path = [self drawPillarByPoint].CGPath;
//    }else {
//        ((CAShapeLayer *)self.layer).path = [self drawPathByPoint].CGPath;
//    }
    [self.shapeLayer removeFromSuperlayer];
    if (_pillars) {
        ((CAShapeLayer *)self.layer).path = [self drawPillarByPoint].CGPath;
    }else {
        CAShapeLayer *shapeLayer_ = [[CAShapeLayer alloc] init];
        shapeLayer_.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        shapeLayer_.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer_.strokeColor = [UIColor colorWithRed:0 green:150.0/255.0 blue:1 alpha:150.0/255.0].CGColor;
        shapeLayer_.lineWidth = 3.0f;
        shapeLayer_.opacity = 1.0f;
        [self.layer addSublayer:shapeLayer_];
        self.shapeLayer = shapeLayer_;
        self.shapeLayer.path = [self drawPathByPoint].CGPath;
    }
}


- (void)setPoints:(NSArray *)points withYMaxValue:(NSInteger)yMaxValue {
    _pillars = nil;
    _points = [points copy];
    _yMaxValue = yMaxValue;
    startIndex = 0;
    [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:NO];

    for (UIView *view in self.subviews) {
        if (view.tag >= 10000) {
            [view removeFromSuperview];
        }
    }
    [self setNeedsDisplay];
}

- (void)setPillars:(NSArray *)pillarValues withYMaxValue:(NSInteger)yMaxValue {
    _pillars = [pillarValues copy];
    _yMaxValue = yMaxValue;
    startIndex = 0;
    [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    for (UIView *view in self.subviews) {
        if (view.tag >= 10000) {
            [view removeFromSuperview];
        }
    }
    [self setNeedsDisplay];
}

- (void)setVercitalLine:(NSArray *)dataArray {
    for (UIView *view in self.subviews) {
        if (view.tag > 70 && view.tag < 90) {
            [view removeFromSuperview];
        }
    }
    
    float rate = GRAPH_HEIGHT / (CGFloat)_yMaxValue;
    CGFloat height = GRAPH_HEIGHT;
    if (self.points) {
        if ([[self.points valueForKeyPath:@"@max.floatValue"] floatValue] * rate > GRAPH_HEIGHT - MAX_PADHEIGHT) {
            rate = (height - MAX_PADHEIGHT) / (CGFloat)_yMaxValue;
        }
    }
    else {
        if ([[self.pillars valueForKeyPath:@"@max.floatValue"] floatValue] * rate > GRAPH_HEIGHT - MAX_PADHEIGHT) {
            rate = (height - MAX_PADHEIGHT) / (CGFloat)_yMaxValue;
        }
    }
    
    NSArray *colors = @[[UIColor colorWithRed:0 green:228.0/255.0 blue:0 alpha:0.5],
                        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0 alpha:0.5],
                        [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:0.5],
                        [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.5],
                        [UIColor colorWithRed:153.0/255.0 green:0 blue:76.0/255.0 alpha:0.5],
                        [UIColor colorWithRed:126.0/255.0 green:0 blue:35.0/255.0 alpha:0.5]];
    for (int j = 0; j < [dataArray count]; j++) {
        NSInteger yValue = [[dataArray objectAtIndex:j] integerValue];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - yValue * rate, self.contentSize.width, 0.5)];
        line.alpha = 0.6;
        line.backgroundColor = LINE_COLOR;
        line.tag = 71 + j;
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        if (_pillars) {
            continue;
        }else if (j < [dataArray count]) {
            CGRect bgFrame = CGRectZero;
            if (j > 0) {
                bgFrame = CGRectMake(0, height - [[dataArray objectAtIndex:j] integerValue] * rate, self.contentSize.width, ([[dataArray objectAtIndex:j] floatValue] - [[dataArray objectAtIndex:j - 1] floatValue]) * rate);
            }else {
                bgFrame = CGRectMake(0, height - [[dataArray objectAtIndex:j] floatValue] * rate, self.contentSize.width, [[dataArray objectAtIndex:j] floatValue] * rate);
            }
            UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
            bgView.alpha = 0.7;
            bgView.tag = 81 + j;
            bgView.backgroundColor = colors[j];
            [self addSubview:bgView];
        }
    }
}


//------------------------------

- (UIBezierPath *)drawPathByPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self pointAtIndex:i];
//        NSLog(@"pox = %f, poy = %f", point.x, point.y);
        if(i == startIndex) {
            [path moveToPoint:point];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(point.x, 0, 0.5, GRAPH_HEIGHT)];
        line.alpha = 0.6;
        line.backgroundColor = LINE_COLOR;
        line.tag = 11000 + i;
        [self addSubview:line];
        
        if (point.y != GRAPH_HEIGHT) {
            UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            pointView.backgroundColor = [UIColor whiteColor];
            pointView.layer.cornerRadius = 5;
            pointView.center = point;
            pointView.tag = 10000 + i;
            [self addSubview:pointView];
            [path addLineToPoint:point];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointView.frame.origin.x - 10, pointView.frame.origin.y - 14, PillarWIDTH, 14)];        valueLabel.text = self.shouldFloat ? [self.points objectAtIndex:i] : [[Configure sharedInstance] removeDotByValue:[self.points objectAtIndex:i]];
            valueLabel.textColor = BLACK_COLOR;
            valueLabel.font = [UIFont systemFontOfSize:12];
            valueLabel.tag = 15000 + i;
            valueLabel.textAlignment = NSTextAlignmentCenter;
            valueLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:valueLabel];
        }else {
            [path moveToPoint:point];
            startIndex = i + 1;
        }
    }
    [path strokeWithBlendMode:kCGBlendModeOverlay alpha:1.0];
    return path;
}

- (UIBezierPath *)drawPillarByPoint {
    UIBezierPath *line = [UIBezierPath bezierPath];
    NSArray *colors = @[[UIColor colorWithRed:0 green:228.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:227.0/255.0 green:207.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0],
                        [UIColor colorWithRed:153.0/255.0 green:0 blue:76.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:126.0/255.0 green:0 blue:35.0/255.0 alpha:1.0]];
    for (NSInteger i = 0; i < self.pillars.count; i++) {
        CGPoint point = [self pillarAtIndex:i];
//        NSLog(@"pox = %f, poy = %f", point.x, point.y);
        UIView *pillarView = [[UIView alloc] initWithFrame:CGRectMake(0, point.y, PillarWIDTH, self.frame.size.height - 30 - point.y)];
        NSInteger index = 0;
        float value = [[self.pillars objectAtIndex:i] floatValue];
        if (value > 50 && value <= 100 ) {
            index = 1;
        }else if (value > 100 && value <= 150) {
            index = 2;
        }else if (value > 150 && value <= 200) {
            index = 3;
        }else if (value > 200 && value <= 300) {
            index = 4;
        }else if (value > 300) {
            index = 5;
        }
        pillarView.backgroundColor = colors[index];
        pillarView.center = CGPointMake(point.x, (self.frame.size.height - 30 + pillarView.frame.origin.y) / 2);
        pillarView.tag = 20000 + i;
        [self addSubview:pillarView];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(pillarView.frame.origin.x, self.frame.size.height - 30 -pillarView.frame.size.height - 20, PillarWIDTH, 20)];
        valueLabel.text = self.shouldFloat ? [self.pillars objectAtIndex:i] : [[Configure sharedInstance] removeDotByValue:[self.pillars objectAtIndex:i]];
        if ([valueLabel.text isEqualToString:@"0"] || [valueLabel.text isEqualToString:@"0.0"]) {
            valueLabel.text = @"";
        }
        valueLabel.textColor = colors[index];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.tag = 25000 + i;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:valueLabel];

    }
    return line;
}

- (CGPoint)pointAtIndex:(NSInteger)index{
    CGFloat ySpace = GRAPH_HEIGHT / _yMaxValue;
    if ([[self.points valueForKeyPath:@"@max.floatValue"] floatValue] > _yMaxValue - MAX_PADHEIGHT) {
        ySpace = (GRAPH_HEIGHT - MAX_PADHEIGHT) / _yMaxValue;
    }
    
    return CGPointMake(25 + index * (15 + PillarWIDTH), GRAPH_HEIGHT - ySpace * [[self.points objectAtIndex:index] floatValue]);
}

- (CGPoint)pillarAtIndex:(NSInteger)index {
    CGFloat ySpace = GRAPH_HEIGHT / _yMaxValue;
    if ([[self.pillars valueForKeyPath:@"@max.floatValue"] floatValue] > _yMaxValue - MAX_PADHEIGHT) {
        ySpace = (GRAPH_HEIGHT - MAX_PADHEIGHT) / _yMaxValue;
    }
    return CGPointMake(25 + index * (15 + PillarWIDTH), GRAPH_HEIGHT - ySpace * [[self.pillars objectAtIndex:index] floatValue]);
}


- (void)setFillColors:(NSArray *)fillColors{
    [gradient removeFromSuperlayer];
    gradient = nil;
    if (fillColors.count) {
        NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:fillColors.count];
        for (UIColor *color in fillColors) {
            if ([color isKindOfClass:[UIColor class]]) {
                [colors addObject:(id)[color CGColor]];
            }else{
                [colors addObject:(id)color];
            }
        }
        _fillColors = colors;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = _fillColors;
        [self.shapeLayer addSublayer:gradient];
    }else {
        _fillColors = fillColors;
    }
    [self setNeedsDisplay];
    
}









@end
