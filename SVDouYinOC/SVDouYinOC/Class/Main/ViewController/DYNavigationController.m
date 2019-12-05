//
//  DYNavigationController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYNavigationController.h"

@interface DYNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation DYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.interactivePopGestureRecognizer.delegate = (id)self;
    [[UINavigationBar appearance] setTintColor:RGB_COLOR(14.0, 15.0, 26.0, 1.0)];
    [[UINavigationBar appearance] setBarTintColor:RGB_COLOR(14.0, 15.0, 26.0, 1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];

    //self.navigationBar.barTintColor = [UIColor blackColor];
    //self.navigationBar.translucent = NO;
    //self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void) backAction {
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
