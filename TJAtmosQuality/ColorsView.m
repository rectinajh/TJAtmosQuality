//
//  ColorsView.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "ColorsView.h"

@implementation ColorsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();   //获得当前对象的上下文
    CGRect bounds = CGContextGetClipBoundingBox(context);   //获得绘制区域
    
    //渐变色配置
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colors[] =
    {
        0.0 / 255.0, 228.0 / 255.0, 0.0 / 255.0, 1.00,  //起始位置颜色
        255.0 / 255.0, 255.0 / 255.0, 0.0 / 255.0, 1.00,
        255.0 / 255.0, 126.0 / 255.0, 0.0 / 255.0, 1.00,
        255.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
        153.0 / 255.0, 0.0 / 255.0, 76.0 / 255.0, 1.00,
        126.0 / 255.0, 0.0 / 255.0, 35.0 / 255.0, 1.00,    //结束位置颜色
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    //配置起始点和结束点位置
    CGPoint start = CGPointMake(bounds.origin.x + bounds.size.width * 0.00, bounds.origin.y);  //起始位置
    CGPoint end = CGPointMake(bounds.origin.x + bounds.size.width * 1.00, bounds.origin.y);    //结束位置
    NSLog(@"start:%@ end:%@", NSStringFromCGPoint(start), NSStringFromCGPoint(end));
    
    //可选参数配置
    CGGradientDrawingOptions options = 0;
    //  options |= kCGGradientDrawsBeforeStartLocation;
    //	options |= kCGGradientDrawsAfterEndLocation;
    
    //开始绘制！
    CGContextDrawLinearGradient(context, gradient, start, end, options);
    
    CGGradientRelease(gradient);
}


- (void)drawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint
                  options:(CGGradientDrawingOptions) options
               startColor:(UIColor*)startColor
                 endColor:(UIColor*)endColor
{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
}

@end
