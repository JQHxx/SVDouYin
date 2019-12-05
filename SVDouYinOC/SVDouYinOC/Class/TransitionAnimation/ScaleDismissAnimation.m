//
//  ScaleDismissAnimation.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "ScaleDismissAnimation.h"
#import "DYSameCityViewController.h"
#import "DYRecommentViewController.h"
#import "DYSameCityCell.h"

@implementation ScaleDismissAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        _centerFrame = CGRectMake((APP_WIDTH - 5)/2, (APP_HEIGHT - 5)/2, 5, 5);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    DYRecommentViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    /*
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    DYSameCityViewController *sameCityVC = toVC.viewControllers.firstObject;
     */
    UINavigationController *navVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UINavigationController *navVC = ((UINavigationController *)tabBarVC.selectedViewController);
    DYSameCityViewController *toVC = navVC.viewControllers.firstObject;

    UIView *selectCell = (DYSameCityCell *)[toVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromVC.currentIndex inSection:0]];
    
    UIView *snapshotView;
    CGFloat scaleRatio;
    CGRect finalFrame;
    if(selectCell) {
        snapshotView = [selectCell snapshotViewAfterScreenUpdates:NO];
        scaleRatio = fromVC.view.frame.size.width/selectCell.frame.size.width;
        snapshotView.layer.zPosition = 20;
        finalFrame = [toVC.collectionView convertRect:selectCell.frame toView:[toVC.collectionView superview]];
    }else {
        snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        scaleRatio = fromVC.view.frame.size.width/APP_WIDTH;
        finalFrame = _centerFrame;
    }
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:snapshotView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    fromVC.view.alpha = 0.0f;
    snapshotView.center = fromVC.view.center;
    snapshotView.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         snapshotView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         snapshotView.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         [transitionContext finishInteractiveTransition];
                         [transitionContext completeTransition:YES];
                         [snapshotView removeFromSuperview];
                     }];
}

@end
