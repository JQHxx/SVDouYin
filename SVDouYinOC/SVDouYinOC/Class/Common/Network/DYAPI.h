//
//  DYAPI.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYAPI : NSObject

// 服务器基本地址
@property (nonatomic, copy, class, readonly) NSString *serverURL;

@end

NS_ASSUME_NONNULL_END
