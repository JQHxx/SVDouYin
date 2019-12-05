//
//  CacheKey.m
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import "ICacheKey.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ICacheKey

/**
 * get cache key
 */
+ (NSString *)getKey: (NSString *)requestURL params: (NSDictionary *)params {
    
    if(!params || params.count == 0){
        return requestURL;
    }
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    NSString *originalStr = [NSString stringWithFormat:@"%@%@",requestURL,paraString];
    return [self md5:originalStr];

}


#pragma mark - md5
+ (NSString *)md5:(NSString *)str{
    
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(input, (CC_LONG)strlen(input), result);
    #pragma clang diagnostic pop
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

@end
