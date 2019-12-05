//
//  DYUserDefaultsUtil.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/15.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYUserDefaultsUtil.h"

@implementation DYUserDefaultsUtil

#define kUserDefaults  [NSUserDefaults standardUserDefaults]

+ (void)setSearchHistoryList:(NSArray <NSString *>*)searchHistoryList {
    [kUserDefaults setObject:searchHistoryList forKey:@"Search_history"];
    [kUserDefaults synchronize];
}

+ (NSArray<NSString *> *)searchHistoryList {
    return [kUserDefaults objectForKey:@"Search_history"];
}

@end
