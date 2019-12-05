//
//  AppDelegate.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "AppDelegate.h"
#import "DYTabBarController.h"
#import <Bugly/Bugly.h>
#import "NetworkHelper.h"
#import "WebSocketManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = [DYTabBarController new];
    [self.window makeKeyAndVisible];
    [self adapterOSVersion];
    [self setupTXLiteAVSDK];
    [Bugly startWithAppId:@"61c5cc17bb"];

    [NetworkHelper startListening];
    [[WebSocketManager shareManager] connect];
    return YES;
}

/**
 适配iOS11以上的系统
 */
- (void) adapterOSVersion {
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];
    }
}

#pragma mark - 第三方
// 腾讯短视频
- (void) setupTXLiteAVSDK {
    NSString * const licenceURL = @"http://license.vod2.myqcloud.com/license/v1/1049fdfeea84ab58e185cfbf32d1317c/TXUgcSDK.licence";
    NSString * const licenceKey = @"447effc7b5f8770e0039c98e5f8cbd59";
    [TXUGCBase setLicenceURL:licenceURL key:licenceKey];
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    // 日志配置
    [TXLiveBase setConsoleEnabled:YES];
    [TXLiveBase setLogLevel:LOGLEVEL_DEBUG];
}



@end
