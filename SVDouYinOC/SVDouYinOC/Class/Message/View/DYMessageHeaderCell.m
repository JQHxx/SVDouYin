//
//  DYMessageHeaderCell.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/14.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYMessageHeaderCell.h"

@implementation DYMessageHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Private methods
- (void) setupUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.right.mas_equalTo(self.contentView);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(16);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (void)setCommonModel:(DYCommonModel *)commonModel {
    _commonModel = commonModel;
    self.iconImageView.image = [UIImage imageNamed:commonModel.image];
    self.nameLabel.text = commonModel.title;
}

@end
