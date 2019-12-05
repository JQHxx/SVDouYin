//
//  DYScanQRCodeViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYScanQRCodeViewController.h"
#import "StyleDIY.h"

@interface DYScanQRCodeViewController ()

@end

@implementation DYScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫一扫";
    self.cameraInvokeMsg = @"相机启动中";
    self.style = [StyleDIY InnerStyle];
    self.isOpenInterestRect = YES;
    self.libraryType = SLT_Native;
    self.scanCodeType = SCT_QRCode;
    [self setupNavBar];
}

#pragma mark - Private methods
- (void) setupNavBar {
    // 扫码
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    //[rightButton setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [rightButton setTitle:@"相册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Event response
- (void) selectImageAction {
    // 关于系统相册遮挡问题
    // picker.navigationBar.translucent = NO;
    [self openLocalPhoto:NO];
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];

        return;
    }

    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }

    LBXScanResult *scanResult = array[0];

    NSString*strResult = scanResult.strScanned;

    self.scanImage = scanResult.imgScanned;

    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }

    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...

    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {

        strResult = @"识别失败";
    }

    __weak __typeof(self) weakSelf = self;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码内容" message:strResult preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reStartDevice];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{

}

@end
