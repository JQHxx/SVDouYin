//
//  IDataManager.m
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import "IDataManager.h"

@implementation IDataManager

+ (NSDictionary *) dataToDict: (NSData *) data {
    if (!data) {
        return [NSDictionary dictionary];
    }
    // NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return jsonDict;
    
}

+ (NSData *) objToData: (id) obj {
    if (!obj) {
        return [NSData new];
    }
    return [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
}

+ (NSData *)getData:(id) responseObject {
    NSData *resultData = [[NSData alloc]init];
    if ([responseObject isKindOfClass:[NSString class]]) {
        resultData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
        resultData = [IDataManager objToData:responseObject];
    } else if ([responseObject isKindOfClass:[NSData class]]) {
        resultData = responseObject;
    }
    return resultData;
}

@end
