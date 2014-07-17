//
//  TMEGoogleAnalyticsAppDelegateService.m
//  ThreeMin
//
//  Created by Khoa Pham on 7/16/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMEGoogleAnalyticsAppDelegateService.h"
#import "GAI.h"

@implementation TMEGoogleAnalyticsAppDelegateService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    //    [GAI sharedInstance].debug = YES;
    [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS_APP_KEY];
    //    [GAI sharedInstance].debug = YES;

    return YES;
}

@end
