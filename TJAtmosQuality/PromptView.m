//
//  PromptView.m
//  TJAQ
//
//  Created by LiWei on 14-8-1.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *wxtsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 280, 20)];
        wxtsLabel.text = @"温馨提示：";
        wxtsLabel.textColor = [UIColor whiteColor];
        wxtsLabel.font = [UIFont systemFontOfSize:14];
        wxtsLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:wxtsLabel];
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 280, 20)];
        errorLabel.text = @"仪器校准";
        errorLabel.textColor = [UIColor whiteColor];
        errorLabel.font = [UIFont systemFontOfSize:16];
        errorLabel.backgroundColor = [UIColor clearColor];
        errorLabel.tag = 150;
        [self addSubview:errorLabel];
        errorLabel.hidden = YES;
                          
        //--------
        NSArray *imgNames = @[@"sprot", @"kid", @"Protection", @"windows"];
        for (int i = 0; i < 4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40 + i * (60 + 5), 60, 60)];
            imageView.image = [UIImage imageNamed:imgNames[i]];
            imageView.tag = 200 + i;
            [self addSubview:imageView];
            imageView.hidden = YES;
            
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 50 + i * (60 + 5), 220, 40)];
            infoLabel.textColor = [UIColor whiteColor];
            infoLabel.numberOfLines = 0;
            infoLabel.font = [UIFont boldSystemFontOfSize:14];
            infoLabel.backgroundColor = [UIColor clearColor];
            infoLabel.tag = 300 + i;
            [self addSubview:infoLabel];
            infoLabel.hidden = YES;
        }
    }
    return self;
}

- (void)applyInfoDataWithLevel:(NSString *)level {
    if ([level isEqualToString:@"error"]) {
        [self viewWithTag:150].hidden = NO;
        for (int i = 0; i < 4; i++) {
            [self viewWithTag:200 + i].hidden = YES;
            [self viewWithTag:300 + i].hidden = YES;
        }
        return;
    }
    [self viewWithTag:150].hidden = YES;
    NSArray *infos = nil;
    switch ([level integerValue]) {
        case 1:
            infos = @[@"适宜户外运动", @"老年人及儿童适宜外出", @"各类人群可正常活动", @"适宜开窗通风"];
            break;
        case 2:
            infos = @[@"极少数异常敏感人群应减少户外活动", @"老年人及儿童适宜外出", @"极少数异常敏感人群减少外出", @"适宜开窗通风"];
            break;
        case 3:
            infos = @[@"敏感人群应减少户外活动", @"老年人及儿童应减少长时间、高强度的户外锻炼", @"敏感人群减少外出", @"适当开窗通风"];
            break;
        case 4:
            infos = @[@"一般人群适量减少户外运动", @"老年人及儿童应避免长时间户外锻炼", @"敏感人群不宜外出", @"减少开窗通风"];
            break;
        case 5:
            infos = @[@"避免户外运动", @"老年人及儿童应停留在室内", @"敏感人群外出会有明显症状", @"避免开窗通风"];
            break;
        case 6:
            infos = @[@"停止户外运动", @"老年人及儿童应停留在室内", @"敏感人群外出会有明显症状", @"避免开窗通风"];
            break;
        default:
            break;
    }
    for (int i = 0; i < [infos count]; i++) {
        [self viewWithTag:200 + i].hidden = NO;
        
        UILabel *label = (UILabel *)[self viewWithTag:300 + i];
        label.text = infos[i];
        label.hidden = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
