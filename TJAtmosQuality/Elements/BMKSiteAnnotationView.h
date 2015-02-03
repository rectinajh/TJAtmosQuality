//
//  BMKSiteAnnotationView.h
//  AtmosQuality
//
//  Created by Tjise on 13-11-29.
//  Copyright (c) 2013年 WoshiTV. All rights reserved.
//

#import "BMKAnnotationView.h"

@interface BMKSiteAnnotationView : BMKAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier siteValue:(NSString *)siteValue level:(NSString *)level;

- (void)setTitleString:(NSString *)titleStr withLevel:(NSString *)level;



- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier siteValue:(NSString *)siteValue type:(NSString *)type;

- (void)setTitleString:(NSString *)titleStr withType:(NSString *)type;

@end
