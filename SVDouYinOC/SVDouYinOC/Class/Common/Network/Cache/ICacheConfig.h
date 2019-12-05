//
//  CacheConfig.h
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICacheConfig : NSObject

/**
 * Many users cache
 */
@property (nonatomic, copy) NSString *userId;

/**
 * The effective time（-1 is indefinite in seconds, deafault 7 days 7 * 60 * 60 * 60）
 */
@property (nonatomic, assign) NSTimeInterval effectiveTime;

/**
 * Whether to save locally
 */
@property (nonatomic, assign) BOOL isSave;

/**
 * Whether to read locally
 */
@property (nonatomic, assign) BOOL isRead;

@end
