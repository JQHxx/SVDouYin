//
//  HttpCache.h
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHttpCache : NSObject

/**
 * @brief save to local
 */
+ (void) save: (NSString *) key data: (NSData *) data request: (IBaseRequest *) request;

/**
 * @brief read local
 */
+ (NSData *) read: (NSString *) key request: (IBaseRequest *) request;

@end

