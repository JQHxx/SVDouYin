//
//  DYTabBar.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DYTabBar;
@protocol DYTabBarDelegate <NSObject>

@optional
- (void)tabBar:(DYTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabBarClickPlusButton:(DYTabBar *)tabBar;

@end

@interface DYTabBar : UIView

@property(nonatomic, weak) id<DYTabBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
