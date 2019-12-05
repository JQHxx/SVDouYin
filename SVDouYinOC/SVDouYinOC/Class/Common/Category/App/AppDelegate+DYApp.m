//
//  AppDelegate+DYApp.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/15.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "AppDelegate+DYApp.h"


@implementation AppDelegate (DYApp)

-(UIViewController *)getCurrentVC{

    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];

    if ([superVC isKindOfClass:[UITabBarController class]]) {

        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;

        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {

            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {

            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
