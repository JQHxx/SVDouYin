//
//  HttpRequest.m
//  Mall
//
//  Created by midland on 2019/8/26.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import "IHttpRequest.h"
#import "IBaseRequest.h"
#import "IHttpCache.h"
#import "ICacheKey.h"
#import "IDataBase.h"
#import "IDataManager.h"

/*
const NSString *RequestTypesMap[] = {
    [RequestTypeGET] = @"GET",
    [RequestTypePOST] = @"POST",
    [RequestTypeUPLOAD] = @"UPLOAD",
};
 */

static NSString  *downLoadTempFilePath = @"user/download";

@interface IHttpRequest()


@end

@implementation IHttpRequest
static IHttpRequest *_instance = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self manager];
    }
    return self;
}

+ (instancetype)shareRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IHttpRequest alloc] init];
    });
    return _instance;
}

+(id)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

#pragma mark - Setter & Getter
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // parsing json
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:(NSJSONReadingAllowFragments)];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpg", nil];
    }
    return _manager;
}

- (BOOL) isHasNetWork {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (BOOL) isHasWifi {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

/**
 * HTTPS 证书验证
 */
- (AFSecurityPolicy *)customSecurityPolicy: (NSString *) name {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:name ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc]initWithObjects:cerData, nil];
    
    return securityPolicy;
}

/**
 * GET/POST/UPLOAD request
 */
- (NSURLSessionDataTask *) sendRequest: (IBaseRequest *) request
                              progress: (ProgressBlock) progressBlock
                               success: (SuccessBlock) successBlock
                               failure: (FailureBlock) failureBlock {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", request.baseURL, request.methodName];
    NSLog(@"Request URL ==> %@ Params ==> %@", requestURL, request.params);
    NSString *cacheKey = [ICacheKey getKey:requestURL params:[self getTempParams:request]];
    
     [self setupConfig:request];
    
    if (request.cerName) {
        _manager.securityPolicy = [self customSecurityPolicy:request.cerName];
    }
    // get cache from local
    if (request.cacheConfig.isRead) {
        NSDictionary *dict = [IDataManager dataToDict:[IHttpCache read:cacheKey request: request]];
        if (successBlock && dict) {
            successBlock(dict, YES);
        }
    }
    switch (request.requestType) {
        case RequestTypeGET:
            return [self getRequest:request progress: progressBlock success:^(id responseObject, BOOL isCache) {
                // save data to local
                [self handleSuccessResult:responseObject cacheKey:cacheKey request:request];
                if (successBlock) {
                    successBlock(responseObject, isCache);
                }
            } failure:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        case RequestTypePOST:
            return [self postRequest:request progress: progressBlock success:^(id responseObject, BOOL isCache) {
                // save data to local
                [self handleSuccessResult:responseObject cacheKey:cacheKey request:request];
                if (successBlock) {
                    successBlock(responseObject, isCache);
                }
            } failure:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        case RequestTypeFORM:
            return [self uploadRequest:request progress: progressBlock success:^(id responseObject, BOOL isCache) {
                // save data to local
                [self handleSuccessResult:responseObject cacheKey:cacheKey request:request];
                if (successBlock) {
                    successBlock(responseObject, isCache);
                }
            } failure:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
    }
    
}

#pragma mark - 下载
- (void)downloadRequest: (IDownLoadRequest *)request
progress:(ProgressBlock)progressBlock
 success:(DownLoadSuccessBlock)successBlock
 failure:(FailureBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;

    if (request.downLoadURL) {
        subStringArr = [request.downLoadURL componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:request.downLoadURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          if (progressBlock) {
              progressBlock(downloadProgress);
          }
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (successBlock) {
              //写文件
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  NSData *dataObj = (NSData *)responseObject;
                  //获取Documents文件夹目录,第一个参数是说明获取Doucments文件夹目录，第二个参数说明是在当前应用沙盒中获取，所有应用沙盒目录组成一个数组结构的数据存放
                  NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                  NSString *documentsPath = [docPath objectAtIndex:0];
                  NSString *folderPath = [NSString stringWithFormat:@"%@/%@",documentsPath,downLoadTempFilePath];
                  if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
                      [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                  }
                  NSString *allPath = [NSString stringWithFormat:@"%@/%@/%ld.%@",documentsPath,downLoadTempFilePath,(long)[[NSDate date] timeIntervalSince1970], request.fileType];
                  [dataObj writeToFile:allPath atomically:YES];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      successBlock(allPath);
                  });
              });
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failBlock) {
              failBlock(error);
          }
      }];

}


#pragma mark - private methdos
/**
 * GET
 */
- (NSURLSessionDataTask *)getRequest: (IBaseRequest *) request
                            progress: (ProgressBlock) progressBlock
                             success: (SuccessBlock) successBlock
                             failure: (FailureBlock) failureBlock {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", request.baseURL, request.methodName];
    return [_manager GET:requestURL parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

/**
 * POST
 */
- (NSURLSessionDataTask *)postRequest: (IBaseRequest *) request
                             progress: (ProgressBlock) progressBlock
                              success: (SuccessBlock) successBlock
                              failure: (FailureBlock) failureBlock {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", request.baseURL, request.methodName];
    return [_manager POST:requestURL parameters:request.params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

/**
 * From POST
 */
- (NSURLSessionDataTask *) uploadRequest: (IBaseRequest *)request
                                progress: (ProgressBlock) progressBlock
                                 success: (SuccessBlock)successBlock
                                 failure: (FailureBlock)failureBlock {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", request.baseURL, request.methodName];
    return [_manager POST:requestURL parameters:request.params constructingBodyWithBlock:request.filesData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

/**
 * config request timeout and header
 */
- (void) setupConfig: (IBaseRequest *) request {
    // request timeout
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = request.timeout;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // header
    if (request.header) {
        [request.header enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            [self->_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
}

- (NSDictionary *) getTempParams: (IBaseRequest *) request {
    NSMutableDictionary *tempParams =  request.params == nil ? [NSMutableDictionary dictionary] : [request.params mutableCopy];
    if (request.cacheConfig.userId) {
        tempParams[@"USERID"] = request.cacheConfig.userId;
    }
    return tempParams;
}

- (void) handleSuccessResult: (id) responseObject cacheKey: (NSString *) cacheKey request: (IBaseRequest *) request {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", request.baseURL, request.methodName];
    NSLog(@"%@ Success=>%@", requestURL, [NSString stringWithFormat:@"%@", responseObject]);
    if (request.cacheConfig.isSave) {
        NSData *resultData = [IDataManager getData:responseObject];
        if (resultData) {
            [IHttpCache save:cacheKey data: resultData request: request];
        }
    }
}
@end
