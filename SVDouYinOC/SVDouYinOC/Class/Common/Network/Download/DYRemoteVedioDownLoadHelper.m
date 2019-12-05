//
//  RGRemoteVedioDownLoadHelper.m
//  RedGrass
//
//  Created by wukong on 2019/2/20.
//  Copyright © 2019年 hongcaosp. All rights reserved.
//

#import "DYRemoteVedioDownLoadHelper.h"

static MBProgressHUD *downLoadhud;

@interface DYRemoteVedioDownLoadHelper()

@property (strong, nonatomic) NSURLSessionTask *task;

@end

@implementation DYRemoteVedioDownLoadHelper

+(DYRemoteVedioDownLoadHelper *)downLoadhepler {
    static DYRemoteVedioDownLoadHelper *downLoadhelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        downLoadhelper = [[DYRemoteVedioDownLoadHelper alloc] init];
    });
    return downLoadhelper ;
}

-(void) downLoadRemoteVedioWithUrl:(NSString *)url{
    
    if(url.length == 0){
        [self downloadFailWitherror:nil];
        return;
    }
    IDownLoadRequest *request = [IDownLoadRequest new];
    request.downLoadURL = url;
    request.fileType = @"mp4";
    __weak typeof(self)weakSelf = self;
    [weakSelf showDownLoadHud];

    [[IHttpRequest shareRequest] downloadRequest:request progress:^(NSProgress *progress) {
         long long toSize = progress.completedUnitCount;
         long long totalSize = progress.totalUnitCount;
        [weakSelf downloadProgressWithToSize:toSize totalSize:totalSize];
    } success:^(NSString *path) {
        NSString *fileUrl = path;
        if([fileUrl isKindOfClass: [NSString class]]){
            [weakSelf saveVideo:fileUrl];
        }
        [weakSelf showDownLoadHudWhenSuccess];
    } failure:^(NSError *error) {
        [weakSelf downloadFailWitherror:nil];
    }];
}

//hid hud
-(void)hidDownLoadHud{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downLoadhud) {
            [downLoadhud hideAnimated:YES];
            downLoadhud = nil;
        }
    });
}

//show hud

-(void) showDownLoadHud{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downLoadhud && !downLoadhud.removeFromSuperViewOnHide) {
            [downLoadhud hideAnimated:NO];
            downLoadhud = nil;
        }
        downLoadhud = [MBProgressHUD showActivityMessageInWindow:@"下载中"];
        downLoadhud.mode = MBProgressHUDModeDeterminate;
    });
}

-(void) showDownLoadHudWhenSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (downLoadhud && !downLoadhud.removeFromSuperViewOnHide) {
//            [downLoadhud hideAnimated:NO];
//            downLoadhud = nil;
//        }
//        downLoadhud = [MBProgressHUD showActivityMessageInView:@"下载中"];
//        downLoadhud.mode = MBProgressHUDModeDeterminate;
        if(downLoadhud){
            downLoadhud.label.text = @"下载成功";
            [downLoadhud hideAnimated:YES afterDelay:1.5];
            downLoadhud = nil;
        }
    });
}

//失败
-(void)downloadFailWitherror:(NSError *)error {
     dispatch_async(dispatch_get_main_queue(), ^{
         if(downLoadhud){
             downLoadhud.label.text = @"下载失败";
             [downLoadhud hideAnimated:YES afterDelay:1.5];
             downLoadhud = nil;
         }
//        if (downLoadhud && !downLoadhud.removeFromSuperViewOnHide) {
//            [downLoadhud hideAnimated:NO];
//            downLoadhud = nil;
//        }
//        downLoadhud = [MBProgressHUD showActivityMessageInView:@"下载失败"];
//        downLoadhud.mode = MBProgressHUDModeText;
     });
}

-(void)downloadProgressWithToSize:(long long)toSize totalSize:(long long)totalSize {
    
    CGFloat percent;
    if(totalSize == 0){
        percent = 0;
    }else{
        percent = toSize  / (CGFloat)totalSize;
    }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        downLoadhud.progress = percent;
    });
    NSLog(@"%f",percent);
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

//保存视频完成之后的回调
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }else {
        NSLog(@"保存视频成功");
    }
}


@end
