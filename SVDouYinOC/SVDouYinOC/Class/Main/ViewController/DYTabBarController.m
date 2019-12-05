//
//  DYTabBarController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYTabBarController.h"
#import "DYNavigationController.h"
#import "DYTabBar.h"
#import "DYHomeMainViewController.h"
#import "DYMessageViewController.h"
#import "DYSameCityViewController.h"
#import "DYMineViewController.h"

#import "VideoPreviewViewController.h"
#import "VideoRecordConfig.h"
#import "VideoEditViewController.h"
#import "VideoCompressPreviewController.h"
#import "VideoRecordViewController.h"

@interface DYTabBarController ()<DYTabBarDelegate>

@end

@implementation DYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCustomTabBar];
    [self setupChildVC];
}

-(void)setupCustomTabBar{
    DYTabBar *tabBar = [[DYTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.delegate = self;
    [self.tabBar addSubview:tabBar];
}

-(void)setupChildVC{
    DYHomeMainViewController *homeVC = [[DYHomeMainViewController alloc] init];
    [self addChildViewController:[[DYNavigationController alloc] initWithRootViewController:homeVC]];
    DYSameCityViewController *sameCityVC = [[DYSameCityViewController alloc] init];
    [self addChildViewController:[[DYNavigationController alloc] initWithRootViewController:sameCityVC]];
    DYMessageViewController *messageVC = [[DYMessageViewController alloc] init];
    [self addChildViewController:[[DYNavigationController alloc] initWithRootViewController:messageVC]];
    DYMineViewController *mineVC = [[DYMineViewController alloc] init];
    [self addChildViewController:[[DYNavigationController alloc] initWithRootViewController:mineVC]];
}

#pragma mark - DYTabBarDelegate -

-(void)tabBarClickPlusButton:(DYTabBar *)tabBar{
    [self presentRecordVCWhenVedioBtnClick];
}

-(void)tabBar:(DYTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) presentRecordVCWhenVedioBtnClick{
    VideoRecordViewController *recordVC = [[VideoRecordViewController alloc]initWithConfigure:[VideoRecordConfig defaultConfigure]];
    __weak typeof(recordVC) weakrecordVC = recordVC;
    recordVC.onRecordCompleted = ^(TXUGCRecordResult *result) {
#ifdef UGC_SMART
            const BOOL enableEdit = NO;
            void (^onEdit)(VideoPreviewViewController *previewVC) = nil;
#else
            const BOOL enableEdit = YES;
            void (^onEdit)(VideoPreviewViewController*) = ^(VideoPreviewViewController *previewVC){
                VideoCompressPreviewController *vc = [[VideoCompressPreviewController alloc] init];
                [vc setVideoPath:result.videoPath];
                [previewVC.navigationController pushViewController:vc animated:YES];
            };
#endif
            VideoPreviewViewController* previewController = [[VideoPreviewViewController alloc]
                                                             initWithCoverImage:result.coverImage
                                                             videoPath:result.videoPath
                                                             renderMode:RENDER_MODE_FILL_EDGE
                                                             showEditButton:enableEdit];
            previewController.onTapEdit = onEdit;
        [weakrecordVC.navigationController pushViewController:previewController animated:YES];
//            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:previewController];
//            [weakrecordVC.navigationController presentViewController:nav animated:YES completion:nil];
        };

    DYNavigationController *nar = [[DYNavigationController alloc]initWithRootViewController:recordVC];
    [self presentViewController:nar animated:YES completion:nil];
}

@end
