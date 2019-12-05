//
//  NetworkHelper.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

//network state notification
extern NSString *const NetworkStatesChangeNotification;
//请求地址
extern NSString *const BaseUrl;

@interface NetworkHelper : NSObject

//Reachability
+ (AFNetworkReachabilityManager *)shareReachabilityManager;

+ (void)startListening;

+ (AFNetworkReachabilityStatus)networkStatus;

+ (BOOL)isWifiStatus;

+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status;

@end
