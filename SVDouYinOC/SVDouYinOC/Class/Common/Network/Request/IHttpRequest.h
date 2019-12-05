//
//  HttpRequest.h
//  Mall
//
//  Created by midland on 2019/8/26.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void(^SuccessBlock)(id result, BOOL isCache);
typedef void(^FailureBlock)(NSError *error);
typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^DownLoadSuccessBlock)(NSString *path);

@class IBaseRequest, IDownLoadRequest;
@interface IHttpRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype) shareRequest;

// 是否有网络
- (BOOL) isHasNetWork;

// 是否wift
- (BOOL) isHasWifi;

/**
 * @brief request
 * @param progressBlock progress callback
 * @param successBlock success callback
 * @param failureBlock failure callback
 */
- (NSURLSessionDataTask *) sendRequest: (IBaseRequest *) request
                              progress: (ProgressBlock) progressBlock
                               success: (SuccessBlock) successBlock
                               failure: (FailureBlock) failureBlock;


///  文件下载
/// @param request download request
/// @param progressBlock progress callback
/// @param successBlock  success callback
/// @param failBlock failure callback
- (void)downloadRequest: (IDownLoadRequest *) request
progress: (ProgressBlock) progressBlock
 success: (DownLoadSuccessBlock) successBlock
 failure: (FailureBlock) failBlock;


@end

