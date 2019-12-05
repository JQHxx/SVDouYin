//
//  DYJsonUtil.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYJsonUtil : NSObject

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName;

+(NSArray *)readJson2ArrayWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
