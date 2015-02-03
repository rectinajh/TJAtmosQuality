// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ConfigManager.h"
#import "SiteObject.h"

static NSString * const AFAppDotNetAPIBaseURLString = SERVER_URL;
//SERVER_URL

@implementation AFAppDotNetAPIClient

@synthesize delegate;

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        [_sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        
    });
    
    return _sharedClient;
}

- (void)requestDataInView:(UIView *)view withURL:(NSString *)url forTarget:(id)target {
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    view.userInteractionEnabled = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:SERVER_URL]]];
    [self.operationQueue addOperation:[self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        view.userInteractionEnabled = YES;
        NSLog(@"url = %@  finished", url);
        if ([url hasSuffix:@"buildJsonAction!findAllStations"]) {
            [self parserSitesInfoData:responseObject];
        }else if ([url hasSuffix:@"buildJsonAction!findAll"]) {
            [self parserSitesData:responseObject];
            if (target) {
                [target getAllSitesFinished];
            }
        }else if ([url hasSuffix:@"buildJsonAction!findWarning"]) {
            NSLog(@"re obj = %@", responseObject);
            if (target) {
                [target getWarningString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
            }
        }else {
            if (target) {
                [target getTenderData:[self parserSiteTenderData:responseObject]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        NSLog(@"url == %@,  error === %@", url, [error localizedDescription]);
        view.userInteractionEnabled = YES;
    }]];
}

- (void)parserSitesData:(id)httpData {
    if (![httpData isKindOfClass:[NSData class]]) {
        NSLog(@"http request data formate error");
    }
    
    NSMutableArray *sites = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSMutableString *responseString = [NSMutableString stringWithString:[[NSString alloc] initWithData:httpData encoding:NSUTF8StringEncoding]];
    [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [responseString deleteCharactersInRange:NSMakeRange(0, 1)];
    [responseString deleteCharactersInRange:NSMakeRange([responseString length] - 1, 1)];
    
    NSArray *array = [responseString componentsSeparatedByString:@"},"];
    for (int i = 0; i < [array count]; i++) {
        NSMutableString *siteString = [NSMutableString stringWithString:array[i]];
        [siteString deleteCharactersInRange:NSMakeRange(0, 1)];
        NSArray *siteArray = [siteString componentsSeparatedByString:@","];
        SiteObject *site = [[SiteObject alloc] init];
        for (int j = 0; j < [siteArray count]; j++) {
            NSString *string = siteArray[j];
            NSArray *arr = [string componentsSeparatedByString:@":"];
            if ([[arr firstObject] isEqualToString:@"'AQI'"]) {
                site.AQI = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'airPollutionLevel'"]) {
                NSMutableString *temp = [NSMutableString stringWithString:[arr lastObject]];
                site.airPollutionLevel = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'CriticalPollutants'"]) {
                NSMutableString *temp = [NSMutableString stringWithString:[arr lastObject]];
                site.CriticalPollutants = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'datetime'"]) {
                site.datetime = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'clientid'"]) {
                site.clientid = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'SO2'"]) {
                site.SO2 = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'SO2_24H'"]) {
                site.SO2_24H = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'NO2'"]) {
                site.NO2 = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'NO2_24H'"]) {
                site.NO2_24H = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'CO'"]) {
                site.CO = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'CO_24H'"]) {
                site.CO_24H = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'PM25'"]) {
                site.PM25 = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'PM25_24H'"]) {
                site.PM25_24H = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'PM10'"]) {
                site.PM10 = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'PM10_24H'"]) {
                site.PM10_24H = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'O3'"]) {
                site.O3 = [arr lastObject];
            }else if ([[arr firstObject] isEqualToString:@"'O3_8H'"]) {
                site.O3_8H = [arr lastObject];
            }
        }
//        NSLog(@"site object = %@", site);
        [sites addObject:site];
    }
    [[Configure sharedInstance] updateSitesArray:sites];
}


- (void)parserSitesInfoData:(id)httpData {
    if (![httpData isKindOfClass:[NSData class]]) {
        NSLog(@"http request data formate error");
    }
    
    NSMutableArray *sites = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSMutableString *responseString = [NSMutableString stringWithString:[[NSString alloc] initWithData:httpData encoding:NSUTF8StringEncoding]];
    [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [responseString deleteCharactersInRange:NSMakeRange(0, 1)];
    [responseString deleteCharactersInRange:NSMakeRange([responseString length] - 1, 1)];
    
    NSArray *array = [responseString componentsSeparatedByString:@"},"];
    for (int i = 0; i < [array count]; i++) {
        NSMutableString *siteString = [NSMutableString stringWithString:array[i]];
        [siteString deleteCharactersInRange:NSMakeRange(0, 1)];
        NSArray *siteArray = [siteString componentsSeparatedByString:@","];
        SiteObject *site = [[SiteObject alloc] init];
        for (int j = 0; j < [siteArray count]; j++) {
            NSString *string = siteArray[j];
            NSArray *arr = [string componentsSeparatedByString:@":"];
            NSMutableString *temp = [NSMutableString stringWithString:[arr lastObject]];
            
            if ([[arr firstObject] isEqualToString:@"'stationName'"]) {
                site.stationName = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'quyudex'"]) {
                site.quyudex = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'lat'"]) {
                site.lat = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'lng'"]) {
                site.lng = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }else if ([[arr firstObject] isEqualToString:@"'clientId'"]) {
                site.clientid = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
            }
        }
//        NSLog(@"site object = %@", site);
        [sites addObject:site];
    }
    [[Configure sharedInstance] setAQSites:sites];
}


- (NSDictionary *)parserSiteTenderData:(id)httpData {
    if (![httpData isKindOfClass:[NSData class]]) {
        NSLog(@"http request data formate error");
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    NSMutableString *responseString = [NSMutableString stringWithString:[[NSString alloc] initWithData:httpData encoding:NSUTF8StringEncoding]];
    [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [responseString deleteCharactersInRange:NSMakeRange(0, 1)];
    [responseString deleteCharactersInRange:NSMakeRange([responseString length] - 1, 1)];
    
    NSArray *array = [responseString componentsSeparatedByString:@"},"];
    for (int i = 0; i < [array count]; i++) {
        NSMutableString *siteString = [NSMutableString stringWithString:array[i]];
        [siteString deleteCharactersInRange:NSMakeRange(0, 1)];
        if ([array count] == 1) {
            [siteString deleteCharactersInRange:NSMakeRange([siteString length] - 1, 1)];
        }
        NSArray *siteArray = [siteString componentsSeparatedByString:@",'"];
        for (int j = 0; j < [siteArray count]; j++) {
            NSString *string = siteArray[j];
            NSArray *arr = [string componentsSeparatedByString:@":"];
            if ([[arr firstObject] isEqualToString:@"'clientid'"]) {
                [dataDic setObject:[arr lastObject] forKey:@"clientid"];
            }else if ([[arr firstObject] isEqualToString:@"lasttime'"]) {
                [dataDic setObject:[arr lastObject] forKey:@"lasttime"];
            }else {
                NSMutableString *mString = [[NSMutableString alloc] initWithString:[arr lastObject]];
                [mString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mString length])];
                [mString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mString length])];
                
                if ([[arr firstObject] isEqualToString:@"AQI'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"AQI"];
                }else if ([[arr firstObject] isEqualToString:@"SO2'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"SO2"];
                }else if ([[arr firstObject] isEqualToString:@"NO2'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"NO2"];
                }else if ([[arr firstObject] isEqualToString:@"CO'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"CO"];
                }else if ([[arr firstObject] isEqualToString:@"PM25'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"PM25"];
                }else if ([[arr firstObject] isEqualToString:@"PM10'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"PM10"];
                }else if ([[arr firstObject] isEqualToString:@"O3'"]) {
                    [dataDic setObject:[mString componentsSeparatedByString:@","] forKey:@"O3"];
                }
            }
        }
    }
    return dataDic;
}

@end
