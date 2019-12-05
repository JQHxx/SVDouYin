//
//  DYHomeMainRouter.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYHomeMainRouter : NSObject

// push到搜索页面
+(void) pushToSearchViewControllerFromVC:(UIViewController *)vc;

// push到扫一扫页面
+(void) pushToQRcodeScanViewControllerFromVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
