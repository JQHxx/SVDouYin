//
//  NetworkHelper.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "NetworkHelper.h"

NSString *const NetworkStatesChangeNotification = @"NetworkStatesChangeNotification";

//请求地址
// ws://localhost:3000/
NSString *const BaseUrl = @"http://localhost:3000/";
//NSString *const BaseUrl = @"http://116.62.9.17:8080/douyin/";

@implementation NetworkHelper

//Reachability
+(AFNetworkReachabilityManager *)shareReachabilityManager {
    static dispatch_once_t once;
    static AFNetworkReachabilityManager *manager;
    dispatch_once(&once, ^{
        manager = [AFNetworkReachabilityManager manager];
    });
    return manager;
}

+ (void)startListening {
    [[NetworkHelper shareReachabilityManager] startMonitoring];
    [[NetworkHelper shareReachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatesChangeNotification object:nil];
        if(![NetworkHelper isNotReachableStatus:status]) {
            // 游客注册 通过uuid绑定
        }
    }];
}

+ (AFNetworkReachabilityStatus)networkStatus {
    return [NetworkHelper shareReachabilityManager].networkReachabilityStatus;
}

+ (BOOL)isWifiStatus {
    return [NetworkHelper shareReachabilityManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status {
    return status == AFNetworkReachabilityStatusNotReachable;
}


@end
