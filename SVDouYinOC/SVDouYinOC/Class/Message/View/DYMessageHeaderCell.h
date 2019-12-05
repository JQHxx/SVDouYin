//
//  DYMessageHeaderCell.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/14.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYMessageHeaderCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) DYCommonModel *commonModel;

@end

NS_ASSUME_NONNULL_END
