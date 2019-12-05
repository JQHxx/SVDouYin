//
//  IDataBase.h
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDataBase : NSObject

+ (instancetype) shareDataBase;

/**
 * @brief save network response data
 * @param url request url
 * @param data binary data
 * @param cacheTime cache time
 */
- (void) saveData: (NSString *) url data: (NSData *) data cacheTime: (double) cacheTime;

/**
 * @brief query local network data
 * @param url request url
 */
- (NSData *) queryData: (NSString *) url;

/**
 * @brief delete local network data
 * @param url request url
 */
- (void) deleteData: (NSString *) url;

@end
