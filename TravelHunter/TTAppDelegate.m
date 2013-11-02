//
//  TTAppDelegate.m
//  TravelHunter
//
//  Created by Hokila on 2013/11/2.
//  Copyright (c) 2013年 Splashtop. All rights reserved.
//

#import "TTAppDelegate.h"
#import "SVHTTPClient.h"

@implementation TTAppDelegate

+ (TTAppDelegate *)sharedAppDelegate
{
    return (TTAppDelegate *) [UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initURLinfo];
    return YES;
}


-(void)initURLinfo
{
    [[SVHTTPClient sharedClient] setBasePath:TTbasePath];
    [[SVHTTPClient sharedClient] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}


@end
