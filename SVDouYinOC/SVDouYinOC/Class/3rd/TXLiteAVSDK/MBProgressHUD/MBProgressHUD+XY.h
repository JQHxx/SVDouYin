//
//  MBProgressHUD+XY.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

/**
 MBProgressHUD 的二次封装
 */
@interface MBProgressHUD (XY)


+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(float)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(float)aTimer;


+ (MBProgressHUD *)showActivityMessageInWindow:(NSString*)message;
+ (MBProgressHUD *)showActivityMessageInView:(NSString*)message;
+ (MBProgressHUD *)showActivityMessageInWindow:(NSString*)message timer:(float)aTimer;
+ (MBProgressHUD *)showActivityMessageInView:(NSString*)message timer:(float)aTimer;


+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;


+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;


+ (void)hideHUD;
@end
