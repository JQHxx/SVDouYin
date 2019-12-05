//
//  UIButton+WSLTitleImage.h
//  collectionView
//
//  Created by 王双龙 on 2017/11/6.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYButtonStyle) {
    DYButtonStyleImageLeft = 0,                    /** 默认 图片在左，文字在右 */
    DYButtonStyleImageRight = 1,             /** 图片在右，文字在左 */
    DYButtonStyleImageTop = 2,               /** 图片在上，文字在下 */
    DYButtonStyleImageBottom = 3            /** 图片在下，文字在上 */
};

@interface UIButton (DYTitleImage)

/**
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *  @param spacing 图片和文字的间隔
 */
- (void)setButtonStyle:(DYButtonStyle)buttonStyle spacing:(CGFloat)spacing;


@end
