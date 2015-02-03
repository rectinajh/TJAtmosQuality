//
//  WarniViewController.m
//  TJAQ
//
//  Created by LiWei on 14-7-31.
//  Copyright (c) 2014年 LW. All rights reserved.
//

#import "WarniViewController.h"
#import "ConfigManager.h"
#import "ColorsView.h"
#import "AFAppDotNetAPIClient.h"

@interface WarniViewController ()

@end

@implementation WarniViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ColorsView *cView = [[ColorsView alloc] initWithFrame:CGRectMake(40, 80, 240, 30)];
    [self.view addSubview:cView];
    NSArray *values = @[@"0", @"50", @"100", @"150", @"200", @"300", @"400", @"500"];
    CGFloat rate = 240.00 / 500.00;
    for (int i = 0; i < [values count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + [values[i] floatValue] * rate, 110, 20, 15)];
        label.text = values[i];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    UILabel *sywrwLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, 160, 30)];
    sywrwLabel.textColor = [UIColor whiteColor];
    sywrwLabel.font = [UIFont boldSystemFontOfSize:16];
    sywrwLabel.textAlignment = NSTextAlignmentCenter;
    sywrwLabel.layer.cornerRadius = 10.0;
    sywrwLabel.layer.masksToBounds = YES;
    sywrwLabel.backgroundColor = [UIColor clearColor];
    sywrwLabel.tag = 40;
    [self.view addSubview:sywrwLabel];
    
    for (int j = 0; j < 2; j++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(39.5, 75, 1, 35)];
        lineView.backgroundColor = BLACK_COLOR;
        lineView.tag = 50 + j;
        [self.view addSubview:lineView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 40, 20)];
        label.textAlignment = j == 0 ? NSTextAlignmentRight : NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = BLACK_COLOR;
        label.tag = 60 + j;
        [self.view addSubview:label];
    }
    
    [[self.view viewWithTag:30] setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    NSString *url = @"tjhb/buildJsonAction!findWarning";
    [[AFAppDotNetAPIClient sharedClient] requestDataInView:self.navigationController.view withURL:url forTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWarningString:(NSString *)warning {
    NSLog(@"warning string = %@", warning);
    
    UITextView *textView = (UITextView *)[[self.view viewWithTag:30] viewWithTag:31];
    textView.text = warning;
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    
    if ([warning length] == 0) {
        textView.text = @"暂无空气质量预报";
        [[self.view viewWithTag:40] setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        return;
    }
    
    NSArray *array = [warning componentsSeparatedByString:@"，"];
    
    UILabel *sywrw = (UILabel *)[self.view viewWithTag:40];
    NSMutableAttributedString *criticalPollutants = [[NSMutableAttributedString alloc] initWithString:[array lastObject]];
    
    [criticalPollutants deleteCharactersInRange:NSMakeRange(0, 5)];
    [criticalPollutants deleteCharactersInRange:NSMakeRange([criticalPollutants length] - 1, 1)];
    
    if ([criticalPollutants length] > 2) {
        [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(2, [criticalPollutants length] - 2)];
    }else if ([criticalPollutants.string isEqualToString:@"O3"]) {
        [criticalPollutants setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)((__bridge CFStringRef)[UIFont boldSystemFontOfSize:10]), NSFontAttributeName, nil] range:NSMakeRange(1, [criticalPollutants length] - 1)];
    }
    
    NSMutableAttributedString *pollAtt = [[NSMutableAttributedString alloc] initWithAttributedString:criticalPollutants];
    [pollAtt insertAttributedString:[[NSAttributedString alloc] initWithString:@"首要污染物" attributes:nil] atIndex:0];
    sywrw.attributedText = pollAtt;
    sywrw.backgroundColor = [UIColor redColor];
    
    NSArray *values = [[[array objectAtIndex:1] substringFromIndex:5] componentsSeparatedByString:@"-"];
    
    sywrw.backgroundColor = [[Configure sharedInstance] getAQITextColor:[values firstObject]];
    
    CGFloat rate = 240.00 / 500.00;
    [UIView animateWithDuration:0.5 animations:^{
        UIView *line1 = [self.view viewWithTag:50];
        line1.frame = CGRectMake([[values firstObject] floatValue] * rate + 40, line1.frame.origin.y, line1.frame.size.width, line1.frame.size.height);
        
        UIView *line2 = [self.view viewWithTag:51];
        line2.frame = CGRectMake([[values lastObject] floatValue] * rate + 40, line2.frame.origin.y, line2.frame.size.width, line2.frame.size.height);
    } completion:^(BOOL finished) {
        UILabel *label1 = (UILabel *)[self.view viewWithTag:60];
        label1.frame = CGRectMake([[values firstObject] floatValue] * rate, label1.frame.origin.y, label1.frame.size.width, label1.frame.size.height);
        label1.text = [values firstObject];
        
        UILabel *label2 = (UILabel *)[self.view viewWithTag:61];
        label2.frame = CGRectMake([[values lastObject] floatValue] * rate + 40, label2.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
        label2.text = [values lastObject];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
