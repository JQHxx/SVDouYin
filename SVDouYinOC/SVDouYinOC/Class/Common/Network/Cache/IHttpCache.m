//
//  HttpCache.m
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import "IHttpCache.h"
#import "IDataBase.h"

@implementation IHttpCache

+ (void) save: (NSString *) key data: (NSData *) data request: (IBaseRequest *) request {
    [[IDataBase shareDataBase] saveData:key data:data cacheTime:request.cacheConfig.effectiveTime];
}

+ (NSData *) read: (NSString *) key request: (IBaseRequest *) request {
    return [[IDataBase shareDataBase] queryData:key];
}

@end
