//
//  IDataManager.h
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDataManager : NSObject

/**
 * @brief local data to diction
 * @param data local data
 */
+ (NSDictionary *) dataToDict: (NSData *) data;

/**
 * @brief array or dictionary to data
 * @param obj array or dictionary
 */
+ (NSData *) objToData: (id) obj;

/**
 * @brief handle response data
 * @param responseObject network response data
 */
+ (NSData *)getData:(id) responseObject;

@end

