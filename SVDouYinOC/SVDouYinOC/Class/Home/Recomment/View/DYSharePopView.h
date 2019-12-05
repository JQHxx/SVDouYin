//
//  SharePopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYSharePopViewDelegate <NSObject>

- (void) sharePopViewShareItem: (NSInteger) tag;
- (void) sharePopViewActionItem: (NSInteger) tag;

@end

@interface DYSharePopView:UIView

@property (nonatomic, weak) id <DYSharePopViewDelegate> delegate;
@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;

- (void)show;
- (void)dismiss;

@end


@interface ShareItem:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

-(void)startAnimation:(NSTimeInterval)delayTime;

@end
