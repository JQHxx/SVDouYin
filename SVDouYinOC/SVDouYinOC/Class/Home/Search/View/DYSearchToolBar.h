//
//  DYSearchToolBar.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYSearchToolBar : UIView

@property (strong, nonatomic) UISearchBar *searchBar;

@property (copy, nonatomic) void (^backBtnClickBlock)(void);//返回键
@property (copy, nonatomic) void (^searchBtnClickBlock)(NSString *text);//搜索

-(void) becomeFirstReponse;

@end

NS_ASSUME_NONNULL_END
