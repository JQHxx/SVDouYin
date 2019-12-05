//
//  DYAnimationUtil.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYAnimationUtil.h"

@implementation DYAnimationUtil

+ (void) rotationAnimation: (UIView *) view {
    // 要先将transform复位-因为CABasicAnimation动画执行完毕后会自动复位，就是没有执行transform之前的位置，跟transform之后的位置有角度差，会造成视觉上旋转不流畅
    view.transform = CGAffineTransformIdentity;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
