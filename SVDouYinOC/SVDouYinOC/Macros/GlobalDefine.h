//
//  GlobalDefine.h
//  CoverDouyin
//
//  Created by 4wd-ios on 2018/4/13.
//  Copyright © 2018年 ganglv. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

// 屏幕宽度
#define APP_WIDTH [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height

//状态栏高度
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航条高度
#define NAVBAR_HEIGHT 44.0
#define BOTTOM_BAR_HEIGHT 34.0

//底部tabbar高度
#define TABBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20 ? 83 : 49)
//整个顶部的高度
#define TOP_HEIGHT (STATUSBAR_HEIGHT + NAVBAR_HEIGHT)

// rgb颜色转换（16进制->10进制）
#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB
#define RGB_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]

#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

// 适配iOS 11 scrollView
#define  adjustsScrollViewInsets_NO(scrollView)\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
if (@available(iOS 11.0,*))  {\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
} else {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \

#define  adjustsTableViewInsets_NO(scrollView)\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
if (@available(iOS 11.0,*))  {\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;\
} else {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \

// 主线程异步执行
#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }


#endif /* GlobalDefine_h */

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LBXScan_Define_UI     //下载了界面模块
#define LBXScan_Define_Native   //下载了Native模块
#endif
