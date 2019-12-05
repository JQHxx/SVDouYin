//
//  DYHomeMainRouter.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYHomeMainRouter.h"
#import "DYScanQRCodeViewController.h"
#import "DYSearchViewController.h"

@implementation DYHomeMainRouter

// push到搜索页面
+(void) pushToSearchViewControllerFromVC:(UIViewController *)vc {
    DYSearchViewController *scanVc = [[DYSearchViewController alloc]init];
    [vc.navigationController pushViewController:scanVc animated:YES];
}

// push到扫一扫页面
+(void) pushToQRcodeScanViewControllerFromVC:(UIViewController *)vc {
    DYScanQRCodeViewController *scanVc = [[DYScanQRCodeViewController alloc]init];
    [vc.navigationController pushViewController:scanVc animated:YES];
}

@end
