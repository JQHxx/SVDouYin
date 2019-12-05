//
//  DYSameCitySectionReusableView.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/13.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSameCitySectionReusableView.h"

@implementation DYSameCitySectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.right.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

@end
