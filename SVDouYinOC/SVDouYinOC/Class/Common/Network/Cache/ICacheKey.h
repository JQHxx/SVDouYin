//
//  CacheKey.h
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ICacheKey : NSObject

/**
 * @brief get cache key
 */
+ (NSString *)getKey: (NSString *)requestURL params: (NSDictionary *)params;

@end

