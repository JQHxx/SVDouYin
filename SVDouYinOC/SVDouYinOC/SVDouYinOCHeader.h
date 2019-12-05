//
//  Header.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark - 通用
#import "DYPagerModel.h"
#import "DYCommonModel.h"
#import "Network.h"
#import "DYJsonUtil.h"
#import "DYAnimationUtil.h"
#import "DYUserDefaultsUtil.h"
#import "AppDelegate.h"

#pragma mark - 第三方
#import <TYPagerController/TYPagerController.h>
#import <TYPagerController/TYTabPagerBar.h>
#import <AFNetworking.h>
#import "Masonry.h"
#import "YYModel.h"
#import <FBKVOController.h>
#import "YYImage.h"
#import "TXLiteAVSDKHeader.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImage+WebP.h"
#import "MBProgressHUD+XY.h"
#import "MBProgressHUD.h"

#pragma mark - 分类
#import "UISearchBar+DYCore.h"
#import "UIViewController+BackButtonHandler.h"
#import "UINavigationBar+Awesome.h"
#import "UIImage+DYCore.h"
#import "NSString+DYCore.h"
#import "UIImage+Extension.h"
#import "UIButton+DYTitleImage.h"
#import "UIViewController+Present.h"
#import "AppDelegate+DYApp.h"
#import "NSNotification+Keyboard.h"
#import "NSAttributedString+DYCore.h"
#import "NSDate+DYCore.h"


#endif /* Header_h */

typedef void(^RequestSuccessBlock)(id result);
typedef void(^RequestFailureBlock)(NSString *message);

