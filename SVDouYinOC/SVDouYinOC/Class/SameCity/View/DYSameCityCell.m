//
//  DYSameCityCell.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/13.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSameCityCell.h"
#import "DYRecommentModel.h"

@implementation DYSameCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.descLabel];

    // 显示的默认的占位图片的高度
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(5);
    }];
}

- (void) reLayout {
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo([NSNumber numberWithFloat:_recomment.descHeight]);
        make.bottom.mas_equalTo(self.contentView).offset(0);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
        //_contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (void)setRecomment:(DYRecommentData *)recomment {
    _recomment = recomment;
    _descLabel.text = recomment.desc;
    _contentImageView.image = [UIImage imageNamed:@"loading"];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:recomment.video.dynamic_cover.url_list.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    [self reLayout];
}
@end
