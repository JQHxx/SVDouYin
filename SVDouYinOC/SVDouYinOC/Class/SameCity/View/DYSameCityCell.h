//
//  DYSameCityCell.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/13.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellRefreshBlock)(void);

@class DYRecommentData;
@interface DYSameCityCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) DYRecommentData  *recomment;

@property (nonatomic, copy) CellRefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
