//
//  BaseRequest.h
//  Mall
//
//  Created by midland on 2019/8/26.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeGET = 0,
    RequestTypePOST = 1,
    RequestTypeFORM = 2,
};

@class ICacheConfig;
@interface IBaseRequest : NSObject

// server address
@property (nonatomic, copy) NSString *baseURL;
// requet method anem
@property (nonatomic, copy) NSString *methodName;
// https cer name
@property (nonatomic, copy) NSString *cerName;
// default POST request
@property (nonatomic, assign) RequestType requestType;
// request params
@property (nonatomic, strong) NSDictionary *params;
// requet header
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *header;
// request time out
@property (nonatomic, assign) NSTimeInterval timeout;
// file params
@property (nonatomic, copy) void (^filesData)(id<AFMultipartFormData>);

// cache config
@property (nonatomic, strong) ICacheConfig *cacheConfig;

@end

